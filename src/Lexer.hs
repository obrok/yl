module Lexer ( Token(..), lexer ) where

import Text.ParserCombinators.Parsec

data Token
  = Identifier String
  | Type String
  | IntegerConstant Integer
  | StringConstant String
  | Semicolon
  | LParen
  | RParen
  | LBrace
  | RBrace
  | Equals
  | DoubleColon
  deriving (Eq, Show)

semicolon = char ';' *> return Semicolon

identifierHead = letter <|> char '_'

identifier = Identifier <$> (
  (:) <$> identifierHead <*> many alphaNum)

number = IntegerConstant . read <$> (
  (++) <$> option "" (string "-") <*> many1 digit)

stringConstant = StringConstant <$> between (char '"') (char '"') (many $ noneOf "\"")

ylToken
  = semicolon
  <|> identifier
  <|> number
  <|> stringConstant

lexer :: Parser [Token]
lexer = spaces *> many (ylToken <* spaces) <* eof
