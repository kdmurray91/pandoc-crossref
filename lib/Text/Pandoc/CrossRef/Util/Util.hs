{-# LANGUAGE RankNTypes #-}
module Text.Pandoc.CrossRef.Util.Util
  ( module Text.Pandoc.CrossRef.Util.Util
  , module Data.Generics
  ) where

import Text.Pandoc.CrossRef.References.Types
import Text.Pandoc.Definition
import Data.Char (toUpper, toLower, isUpper)
import Data.List (intercalate)
import Data.Maybe (fromMaybe)
import Data.Generics

isFormat :: String -> Maybe Format -> Bool
isFormat fmt (Just (Format f)) = takeWhile (`notElem` "+-") f == fmt
isFormat _ Nothing = False

capitalizeFirst :: String -> String
capitalizeFirst (x:xs) = toUpper x : xs
capitalizeFirst [] = []

uncapitalizeFirst :: String -> String
uncapitalizeFirst (x:xs) = toLower x : xs
uncapitalizeFirst [] = []

isFirstUpper :: String -> Bool
isFirstUpper (x:_) = isUpper x
isFirstUpper [] = False

chapPrefix :: [Inline] -> Index -> [Inline]
chapPrefix delim index = intercalate delim (map (return . Str . uncurry (fromMaybe . show)) index)

-- | Monadic variation on everywhere'
everywhereM' :: Monad m => GenericQ Bool -> GenericM m -> GenericM m

-- Top-down order is also reflected in order of do-actions
everywhereM' q f x
  | q x = f x
  | otherwise = f x >>= gmapM (everywhereM' q f)
