import Text.ParserCombinators.Parsec

newtype Identifier = Identifier String
  deriving Show

data Definition = Definition Identifier Expression
  deriving Show

data Expression
  = Number Integer
  | String String
  | Id Identifier
  | Call [Expression]
  deriving Show

numberLiteral :: Parser Expression
numberLiteral = Number . read <$> many1 digit

stringLiteral :: Parser Expression
stringLiteral = String <$> (char '"' *> many1 (noneOf "\"") <* char '"')

identifier :: Parser Identifier
identifier = fmap Identifier $ (:) <$> (letter <|> char '_') <*> many alphaNum

identifierExpression :: Parser Expression
identifierExpression = Id <$> identifier

whitespace = many1 $ oneOf " \t"

parenthesisedExpression :: Parser Expression
parenthesisedExpression = char '(' *> expression <* char ')'

expressionItem :: Parser Expression
expressionItem = numberLiteral <|> stringLiteral <|> identifierExpression <|> parenthesisedExpression

expression :: Parser Expression
expression = Call <$> sepBy expressionItem whitespace

definition :: Parser Definition
definition = Definition <$> identifier <* whitespace <* char '=' <* whitespace <*> expression

parser = definition <* eof

main :: IO ()
main = print $ parse parser "" "fun = (show thing) _ \"bob\" 1234"
