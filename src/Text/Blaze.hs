{-# LANGUAGE FlexibleInstances, TypeSynonymInstances #-}
-- | BlazeMarkup is a markup combinator library. It provides a way to embed
-- markup languages like HTML and SVG in Haskell in an efficient and convenient
-- way, with a light-weight syntax.
--
-- To use the library, one needs to import a set of combinators. For example,
-- you can use HTML 4 Strict from BlazeHtml package.
--
-- > {-# LANGUAGE OverloadedStrings #-}
-- > import Prelude hiding (head, id, div)
-- > import Text.Blaze.Html4.Strict hiding (map)
-- > import Text.Blaze.Html4.Strict.Attributes hiding (title)
--
-- To render the page later on, you need a so called Renderer. The recommended
-- renderer is an UTF-8 renderer which produces a lazy bytestring.
--
-- > import Text.Blaze.Renderer.Utf8 (renderMarkup)
--
-- Now, you can describe pages using the imported combinators.
--
-- > page1 :: Markup
-- > page1 = html $ do
-- >     head $ do
-- >         title "Introduction page."
-- >         link ! rel "stylesheet" ! type_ "text/css" ! href "screen.css"
-- >     body $ do
-- >         div ! id "header" $ "Syntax"
-- >         p "This is an example of BlazeMarkup syntax."
-- >         ul $ mapM_ (li . toMarkup . show) [1, 2, 3]
--
-- The resulting HTML can now be extracted using:
--
-- > renderMarkup page1
--
module Text.Blaze
    (
      -- * Important types.
      Markup
    , Tag
    , Attribute
    , AttributeValue

      -- * Creating attributes.
    , dataAttribute
    , customAttribute

      -- * Converting values to HTML.
    , ToMarkup (..)
    , preEscapedText
    , preEscapedLazyText
    , preEscapedString
    , unsafeByteString
    , unsafeLazyByteString

      -- * Creating tags.
    , textTag
    , stringTag

      -- * Converting values to attribute values.
    , ToValue (..)
    , preEscapedTextValue
    , preEscapedLazyTextValue
    , preEscapedStringValue
    , unsafeByteStringValue
    , unsafeLazyByteStringValue

      -- * Setting attributes
    , (!)
    ) where

import Data.Monoid (mconcat)

import Data.Text (Text)
import qualified Data.Text.Lazy as LT

import Text.Blaze.Internal

-- | Class allowing us to use a single function for Markup values
--
class ToMarkup a where
    -- | Convert a value to Markup.
    --
    toMarkup :: a -> Markup

instance ToMarkup Markup where
    toMarkup = id
    {-# INLINE toMarkup #-}

instance ToMarkup [Markup] where
    toMarkup = mconcat
    {-# INLINE toMarkup #-}

instance ToMarkup Text where
    toMarkup = text
    {-# INLINE toMarkup #-}

instance ToMarkup LT.Text where
    toMarkup = lazyText
    {-# INLINE toMarkup #-}

instance ToMarkup String where
    toMarkup = string
    {-# INLINE toMarkup #-}

instance ToMarkup Int where
    toMarkup = string . show
    {-# INLINE toMarkup #-}

instance ToMarkup Char where
    toMarkup = string . return
    {-# INLINE toMarkup #-}

instance ToMarkup Bool where
    toMarkup = string . show
    {-# INLINE toMarkup #-}

instance ToMarkup Integer where
    toMarkup = string . show
    {-# INLINE toMarkup #-}

instance ToMarkup Float where
    toMarkup = string . show
    {-# INLINE toMarkup #-}

instance ToMarkup Double where
    toMarkup = string . show
    {-# INLINE toMarkup #-}

-- | Class allowing us to use a single function for attribute values
--
class ToValue a where
    -- | Convert a value to an attribute value
    --
    toValue :: a -> AttributeValue

instance ToValue AttributeValue where
    toValue = id
    {-# INLINE toValue #-}

instance ToValue Text where
    toValue = textValue
    {-# INLINE toValue #-}

instance ToValue LT.Text where
    toValue = lazyTextValue
    {-# INLINE toValue #-}

instance ToValue String where
    toValue = stringValue
    {-# INLINE toValue #-}

instance ToValue Int where
    toValue = stringValue . show
    {-# INLINE toValue #-}

instance ToValue Char where
    toValue = stringValue . return
    {-# INLINE toValue #-}

instance ToValue Bool where
    toValue = stringValue . show
    {-# INLINE toValue #-}

instance ToValue Integer where
    toValue = stringValue . show
    {-# INLINE toValue #-}

instance ToValue Float where
    toValue = stringValue . show
    {-# INLINE toValue #-}

instance ToValue Double where
    toValue = stringValue . show
    {-# INLINE toValue #-}
