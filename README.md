# Ray Tracing on Processing

> **Note**
> This repository includes unrelated histories to merge updates for 2022's course from a different repository.

## component

| file / directory | description |
|:-|:-|
| `.github/workflows/release.yml` | push any tag and generate html, zip and create release |
| `build/` | script to convert md to html |
| `docs/` | source text and images|
| `prt/` | sample project to be distributed |
| `prtex/prtex_a.pde` | Answer for practice Ex.A |
| `prtex/prtex_b_l.pde` | Answer for practice Ex.B. left, `hit.material.Color()` |
| `prtex/prtex_b_r.pde` | Answer for practice Ex.B. right, `hit.normal` |
| `prtex/prtex_cd.pde` | Answer for practice Ex.C and Ex.D |

Each answer under `prtex/` is only the substitution for prt/prt.pde

## build locally

```sh
python3 build/convert.py docs/prt.md -o output_name.html
```

You need some python packages written in `requirement.txt`

## automated build and release

Push any tag to build, zip, and release on GitHub Actions.
The released file is named 'prt.zip' and contains 'Ray Tracing on Processing.html' the text and `prt/*` the sample Processing project.
