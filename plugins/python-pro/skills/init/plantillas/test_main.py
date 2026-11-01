from {{PKG}} import main


def test_main_prints_a_greeting(capsys):
    main()
    assert "Hello" in capsys.readouterr().out
