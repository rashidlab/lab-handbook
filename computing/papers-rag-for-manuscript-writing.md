# Papers RAG for manuscript writing

A workflow for building a retrieval-augmented (RAG) database over a corpus of research papers and
using it while writing a manuscript: for grounded related-work, accurate citations, methods
precedent, and claim-checking. It reuses two pieces we already have rather than inventing new
infrastructure.

This is the manuscript analog of the BIOS 667 course-corpus RAG. The pipeline is corpus-agnostic;
the deltas for papers are bibliographic metadata, the corpus contents, and a writing-focused tool
surface.

## The two building blocks we already have

1. **The `papers` MCP server** (configured in `~/.claude.json`; tools `mcp__papers__*`). It
   searches and downloads PDFs from arXiv, PubMed, bioRxiv/medRxiv, Semantic Scholar, Crossref,
   Scopus, Springer, Wiley, ScienceDirect, Google Scholar (and Sci-Hub). Use it to assemble and
   refresh the corpus.
2. **The `bios667_rag` engine** (`BIOS667/new/rag/`). A reusable PDF -> chunk -> embed ->
   ChromaDB + knowledge-graph pipeline with an MCP server. Reusable modules: `loaders/`
   (PDF ingestion with OCR fallback), `metadata.py`, `chunk.py`, `embed.py` (all-MiniLM-L6-v2),
   `storage.py` (ChromaDB), `graph.py` (knowledge graph), `corpus_index.py` (walk/build/manifest),
   `corpus_query.py` (search), `corpus_mcp_server.py` (serve). Console entry points
   `bios667-index-corpus` and `bios667-corpus` are the patterns to copy.

The papers RAG is the same engine pointed at a papers corpus, with bibliographic metadata and a
manuscript-writing tool surface. Keep it as a sibling package (`papers_rag`) or a parameterized
reuse; use a **separate ChromaDB collection** (e.g. `papers_corpus`) so it never mixes with the
course corpus.

## Step 1: assemble the paper corpus

- Pull candidates with the `papers` MCP: `search_papers` / `search_pubmed` / `search_arxiv` /
  `search_semantic_scholar` by topic, author, year; then `download_paper` (or `get_paper_by_doi`)
  to a `papers/` folder. Add hand-collected PDFs you already have.
- Keep a **bibliography alongside the PDFs**: a `.bib` (or a CSV) with DOI, authors, year, venue,
  title for each file. This is the source of truth for citation keys and lets the RAG attach
  bibliographic metadata. Name PDFs by citation key (e.g. `smith2021lme.pdf`) so provenance is
  obvious.
- Do NOT commit the PDFs or the built database to git (copyright + size); commit the `.bib`,
  the build scripts, and the code. (Same rule as the course repo.)

## Step 2: build the RAG over the papers

Reuse the engine; the only real additions are paper metadata and a `paper` source type.

- **Loaders:** `loaders/pdf_loader` already handles paper PDFs, with the scanned-PDF OCR fallback
  for image-only scans. Capture page numbers during extraction so retrieval can cite a page.
- **Metadata (`ChunkMeta` extended for papers):** `source_type="paper"`, `source_path`,
  `citation_key`, `authors`, `year`, `venue`, `doi`, `section` (intro/methods/results/...),
  `page`. Mirror it to the knowledge graph as `paper` nodes plus `author`, `venue`, and
  (where available) `cites` edges between papers.
- **Chunking:** prose chunking (heading/section-aware, ~600 tokens, overlap) as in `chunk.py`.
  Section-tagged chunks let you target "methods" vs "results" later.
- **Embed + store:** `embed.py` (MiniLM, GPU-aware) into a `papers_corpus` ChromaDB collection via
  `storage.py`. Incremental sha256 manifest (as in `corpus_index.py`) so re-indexing only touches
  new/changed PDFs.
- **Build command:** clone `corpus_index.py:main` as `papers-index` pointed at `papers/`:
  `papers-index --plan` (dry-run: counts, scanned-PDF flags, unindexed) then `papers-index`
  (incremental) and `papers-index --rebuild`. The `--plan` gate is worth keeping: eyeball
  coverage and scanned/failed PDFs before embedding.

## Step 3: serve it with a writing-focused tool surface

Clone `corpus_mcp_server.py` as a `papers-rag` MCP server (register in the manuscript project's
`.mcp.json`). Expose tools framed for writing, all over the shared `search_all` core:

- `search_lit(query, year?, venue?, author?, section?, top_k)` - semantic search across the
  corpus with bibliographic filters; returns passages with citation key, year, page, snippet.
- `find_evidence(claim)` - retrieve the passages most relevant to a sentence you are about to
  write, so you can cite the source that actually supports it.
- `check_claim(claim)` - the manuscript analog of `check_lecture_sync`: return passages that
  support AND passages that appear to contradict the claim, each with citation + snippet, flagged
  for your judgment. It surfaces candidates; it does not adjudicate.
- `find_methods(method)` - locate how prior papers specified a method (estimand, model, software),
  filtered to `section=methods`, for precedent and wording.
- `related_work(topic)` - cluster the top hits by paper to draft a related-work paragraph from
  real sources.

Every result carries `citation_key` + `page` so a retrieved passage maps to an exact, verifiable
location in a specific PDF.

## Step 4: write the manuscript with it

The integration patterns, with the discipline that keeps the work yours:

1. **Related work / framing.** `related_work(topic)` and `search_lit` to find and read the actual
   prior work, then write the paragraph from sources you have read, not from the model's summary.
2. **Citation-as-you-write.** Before attaching a citation to a claim, run `find_evidence(claim)`,
   open the retrieved passage, and confirm it says what you are claiming. Cite the citation key the
   passage came from. This is the direct guard against fabricated or mis-attributed citations
   (LLMs invent plausible references; a retrieved, page-anchored passage cannot be faked into
   existence).
3. **Methods precedent.** `find_methods` to ground your methods section in how the literature
   actually specified the estimand/model, and to match terminology.
4. **Claim-check pass.** Before submission, run `check_claim` on the manuscript's key assertions;
   review the support/contradiction passages; fix anything the literature does not actually back.
5. **Citations log.** Keep a short `CITATIONS.md` (or notes in the `.bib`): for each non-trivial
   citation, the claim, the citation key, and the page/snippet that supports it. This is the audit
   trail and lets a coauthor or reviewer reconstruct why each reference is there.

## Citation integrity (the discipline)

This mirrors "Staying in the Driver's Seat": the RAG accelerates *finding* evidence, but the
judgment - does this passage actually support this sentence, in context - stays yours. The RAG
returns candidates; you verify the passage before the citation ships. Never cite from the model's
paraphrase or from memory; cite from the retrieved, page-anchored text. A citation you cannot
trace to a specific passage in a specific PDF is not ready.

## Lab-fit

- **Data not in git:** PDFs, the ChromaDB collection, and the venv are gitignored; the `.bib`,
  build scripts, and MCP config are committed. (Lab data-storage standard.)
- **Project consistency:** the manuscript reads from *verified sources*, the same way it reads
  computed values from code rather than hardcoding them. The `.bib` + `CITATIONS.md` are the
  provenance record (analogous to `docs/DATA_PROVENANCE.md`).
- **Reproducible build:** `papers-index --plan` then build; one tracking manifest; documented in
  the project README.

## Reuse checklist

- [ ] `papers/` corpus assembled (papers MCP + manual PDFs), named by citation key.
- [ ] `.bib` / bibliography with DOI, authors, year, venue per PDF.
- [ ] `papers_rag` built from the `bios667_rag` modules; `source_type="paper"`; paper metadata
      (authors/year/venue/doi/section/page); separate `papers_corpus` collection.
- [ ] `papers-index --plan` reviewed before the full embed.
- [ ] `papers-rag` MCP server registered in the manuscript project's `.mcp.json`
      (restart Claude Code to load it).
- [ ] `find_evidence` / `check_claim` used per claim during writing; `CITATIONS.md` kept.
- [ ] PDFs / DB / venv gitignored.

## Caveats

- Retrieval quality depends on extraction quality; scanned/figure-heavy PDFs may need OCR (the
  loader attempts it when text extraction is sparse) and still retrieve poorly. Spot-check.
- The embedder (MiniLM) is general-purpose; for highly technical corpora a domain or larger
  embedding model improves recall, at the cost of a larger/slower index.
- `check_claim`/`find_evidence` surface candidates only. They reduce the chance of an unsupported
  or fabricated citation; they do not replace reading the source.
- Respect copyright and publisher terms for downloaded PDFs; keep them local, do not redistribute.
