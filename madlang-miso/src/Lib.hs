{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TemplateHaskell   #-}

module Lib
    ( exec
    ) where


import           Data.FileEmbed (embedStringFile)
import qualified Data.Map       as M
import qualified Data.Set       as S
import           Data.Text      (Text)
import           Miso
import           Miso.String
import           Text.Madlibs   (runText)

sourceFile :: Text
sourceFile = $(embedStringFile "mad-src/{{ project }}.mad")

randomText :: IO Text
randomText = runText [] "noSrc" sourceFile

type Model = Text

data Action
  = Regenerate
  | Write Text
  | NoOp
  deriving (Show, Eq)

exec :: IO ()
exec = startApp App {..}
  where
    initialAction = NoOp
    model  = ""
    update = updateModel
    view   = viewModel
    events = defaultEvents
    subs   = [ keyboardSub keypress ]

backgroundStyle :: [Attribute action]
backgroundStyle = [ style_ $ M.fromList [("color", "#4d4d4d"), ("margin-left", "15%"), ("margin-top", "15%") ] ]

largeFont :: [Attribute action]
largeFont = [ style_ $ M.fromList [("font", "20px \"Comic Sans MS\", Helvetica, sans-serif")] ]

buttonFont :: [Attribute action]
buttonFont = [ style_ $ M.fromList [("font", "50px \"Comic Sans MS\", Helvetica, sans-serif")] ]

buttonTraits :: [Attribute action]
buttonTraits = class_ "button" : buttonFont

fontStyles :: [Attribute action]
fontStyles = [ style_ $ M.fromList [("font", "30px \"Comic Sans MS\", Helvetica, sans-serif")] ]

updateModel :: Action -> Model -> Effect Action Model
updateModel Regenerate m = m <# fmap Write randomText
updateModel (Write t) _  = noEff t
updateModel NoOp m       = noEff m

keypress :: S.Set Int -> Action
keypress keys = if 82 `elem` S.toList keys && 17 `notElem` S.toList keys then Regenerate else NoOp

viewModel :: Model -> View Action
viewModel x = div_ backgroundStyle
    [
      p_ largeFont [ text "Press 'more' or push 'r' for another {{ project }}" ]
    , p_ [] [ div_ (onClick Regenerate : buttonTraits) [ text "more" ] ]
    , p_ fontStyles [ text (toMisoString x) ]
    , p_ [] [ footer ]
    ]

footerParagraph :: [Attribute action]
footerParagraph = [ style_ $ M.fromList [("align", "bottom"), ("position", "absolute"), ("bottom", "200px")] ]

footer :: View Action
footer = footer_ [ class_ "info" ]
    [ p_ footerParagraph
        [ a_ [ href_ "https://github.com/{{ github-username }}/{{ project }}" ] [ text "source" ] ] ]
