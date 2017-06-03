view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (model.message ++ "Hello, world!") ]
        ]
