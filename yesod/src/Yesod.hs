{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}

module Foundation where

import Yesod as Y

data {{ Project }} = {{ Project }}

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

instance Yesod {{ Project }}

getHomeR :: Handler Html
getHomeR = defaultLayout $(whamletFile "web-src/hamlet/index.hamlet")

main :: IO ()
main = warp 3000 HelloWorld
