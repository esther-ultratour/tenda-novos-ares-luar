# Galeria — Novos Ares Luar (Tenda)

Três galerias independentes — **imagens**, **apartamento decorado** e **plantas** — para injeção via script no 3DVista, hospedadas no AWS S3.
Criada a partir do template da galeria Itá Nobre (Tenda).

**Tema:** fundo roxo `#311557`, cor secundária / estado ativo `#662483`, texto `#FFFFFF`.
O lightbox usa um roxo mais fundo (`#1E0B38`); o papel das plantas é branco.

---

## URLs de produção

| Arquivo | URL |
|---------|-----|
| Galeria | `https://skylineip.s3.sa-east-1.amazonaws.com/Tour+Virtual/TENDA/ferramentas/galeria/novos+ares+luar/index.html` |
| Script  | `https://skylineip.s3.sa-east-1.amazonaws.com/Tour+Virtual/TENDA/ferramentas/galeria/novos+ares+luar/inject.js` |

**S3 path:** `s3://skylineip/Tour Virtual/TENDA/ferramentas/galeria/novos ares luar/`

`index.html?mode=imagens | apartamento | plantas` (sem `mode` mostra tudo).

---

## Estrutura

```
index.html        ← galeria (?mode=imagens | apartamento | plantas)
inject.js         ← loader leve para o 3DVista
deploy.ps1        ← deploy para o S3 (Windows)
build_assets.py   ← gera assets/web/ (WebP) a partir do material entregue
assets-map.tsv    ← arquivo entregue → nome final
assets/
├── Lazer/ apartamento/ Plantas/   ← material entregue (já redimensionado; não vai ao S3)
└── web/                           ← o que a galeria consome (vai ao S3)
    ├── imagens/ apartamento/ plantas/
    └── miniaturas/                ← espelha as pastas acima (grade)
```

Nomes publicados: minúsculos, sem espaços e sem acentos (o S3 é case-sensitive).
Os nomes de exibição ficam em `GALLERY_CONFIG` no `index.html`.

## Categorias

| Galeria | Filtros |
|---------|---------|
| Imagens | Todas · Fachada e Acessos · Lazer · Festas e Churrasqueira |
| Apartamento | Todas · Sala e Cozinha · Varanda e Garden · Quartos e Banheiro |
| Plantas | Tipologias (Planta Tipo / Planta Garden) · Implantação |

## Assets

As imagens chegaram já redimensionadas (1080 px de altura); o build só converte para WebP
(lightbox q85, miniatura ≤ 900 px q72) e **nunca amplia**. Plantas: PNG com transparência
assentado sobre branco, recortado no desenho (lightbox q86, miniatura ≤ 1400 px q78).

```powershell
python build_assets.py            # só o que falta
python build_assets.py --force    # tudo
```

Para acrescentar imagens: coloque o arquivo em `assets/`, adicione a linha no TSV,
rode o script e registre o item em `GALLERY_CONFIG.items`.

## Deploy AWS S3

```powershell
./deploy.ps1               # sync + cache-control no HTML/JS
./deploy.ps1 -QuickHtml    # só HTML/JS
```

HTML/JS recebem `no-cache,no-store,must-revalidate`.

## Integração 3DVista

Loader no JavaScript global do projeto e chamadas nos botões — trechos prontos em `3dvista-snippets.md`:

```js
GaleriaImagens(1);       // imagens               · GaleriaImagens(0) fecha
GaleriaApartamento(1);   // apartamento decorado  · GaleriaApartamento(0) fecha
GaleriaPlantas(1);       // plantas               · GaleriaPlantas(0) fecha
```

## Pendências

- **Logo:** o empreendimento não tem logo no material; o cabeçalho usa um texto "Novos Ares / Luar".
- **Legendas:** descrevem o que se vê em cada render; conferir com o book.
- **Resíduos do Itá Nobre** (`video-gallery.html`, `assets/logo-ita.gif`, `assets/brand/`): não são usados nem publicados; podem ser removidos do repositório.
