# Compare Gzip vs Zopfli

For context see https://github.com/rails/sprockets/issues/26#issuecomment-161733335

```bash
git clone ...

cd gz-compare/

bundle

bundle exec ruby compare.rb
```

## Results

```
$ bundle exec ruby compare.rb
----------------------------------------------------------------------
                    File: codetriage.js
                 Gzipped: 43752 bytes
Zopflied (1 iterations): 42257 bytes (96.58% of codetriage.js.gzip.gz)
Zopflied (15 iterations): 42199 bytes (96.45% of codetriage.js.gzip.gz)
Zopflied (225 iterations): 42185 bytes (96.42% of codetriage.js.gzip.gz)
----------------------------------------------------------------------
                    File: codetriage.css
                 Gzipped: 5018 bytes
Zopflied (1 iterations): 4848 bytes (96.61% of codetriage.css.gzip.gz)
Zopflied (15 iterations): 4828 bytes (96.21% of codetriage.css.gzip.gz)
Zopflied (225 iterations): 4824 bytes (96.13% of codetriage.css.gzip.gz)
----------------------------------------------------------------------
                    File: codetriage.svg
                 Gzipped: 1466 bytes
Zopflied (1 iterations): 1403 bytes (95.7% of codetriage.svg.gzip.gz)
Zopflied (15 iterations): 1399 bytes (95.43% of codetriage.svg.gzip.gz)
Zopflied (225 iterations): 1398 bytes (95.36% of codetriage.svg.gzip.gz)
----------------------------------------------------------------------
```
