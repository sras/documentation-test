{-# LANGUAGE MultiParamTypeClasses #-}
module Main where

import Opaleye
import Data.Profunctor.Product (p3)

import Database.PostgreSQL.Simple

userTable :: Table 
    (Column PGInt4, Column PGText, Column PGText) 
    (Column PGInt4, Column PGText, Column PGText)
userTable = Table "users" (p3 (
    required "id",
    required "name",
    required "email"
    ))

newtype UserId = UserId Int deriving (Show)

instance QueryRunnerColumnDefault PGInt4 UserId where
  queryRunnerColumnDefault = UserId <$> queryRunnerColumnDefault

getUserRows :: IO [(UserId, String, String)]
getUserRows = do
  conn <- connect defaultConnectInfo { connectDatabase = "scratch"}
  runQuery conn $ queryTable userTable

main :: IO ()
main = do
  rows <- getUserRows
  putStrLn $ show rows

-- Output
-- >main
-- [(UserId 1,"John","john@mail.com"),(UserId 2,"Bob","bob@mail.com"),(U
-- serId 3,"Alice","alice@mail.com")]
