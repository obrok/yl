module LexerSpec (spec) where

import qualified Lexer (lexer)
import Lexer (Token(..))
import qualified Text.ParserCombinators.Parsec as Parsec
import Text.ParserCombinators.Parsec.Error (Message(..))
import qualified Data.Foldable as Foldable
import qualified Data.Either as Either

import Test.Hspec

cases =
  [ ("", Right [])
  , (";", Right [Semicolon])
  , ("something", Right [Identifier "something"])
  , ("_something", Right [Identifier "_something"])
  , ("_s0mething", Right [Identifier "_s0mething"])
  , ("_", Right [Identifier "_"])
  , ("a b", Right [Identifier "a", Identifier "b"])
  , (" a b", Right [Identifier "a", Identifier "b"])
  , ("a b ", Right [Identifier "a", Identifier "b"])
  , ("a\t\v\nb", Right [Identifier "a", Identifier "b"])
  , ("123", Right [IntegerConstant 123])
  , ("-123", Right [IntegerConstant (-123)])
  , ("\"123\"", Right [StringConstant "123"])
  ]

errors = 
  [
  ]

spec = describe "LexerSpec" $ do
  Foldable.forM_ cases (\(input, result) ->
    it ("lexes a \"" ++ input ++ "\"") $ do
      Parsec.parse Lexer.lexer "" input `shouldBe` result)

  Foldable.forM_ errors (\input ->
    it ("errors on \"" ++ input ++ "\"") $ do
      Either.isLeft (Parsec.parse Lexer.lexer "" input) `shouldBe` True)
