.PHONY: test

test:
	cabal exec runhaskell -- -isrc -itest test/Spec.hs
