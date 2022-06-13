#Include "Totvs.ch"

#Define PADDING 2
#Define PG_H_INI 0000
#Define PG_H_FIM 2300

/*/{Protheus.doc} PrinterHelp
Classe utilit�ria para ajudar na constru��o de 
relat�rio gr�ficos com FwMsPrinter.

@type class
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 30/11/2021

@obs https://github.com/denistofoli/Advpl-PrinterHelp (MIT License)
/*/
Class PrinterHelp
    Data oPrn
	Data vPos
	Data hPos

    Method New()
    Method Center()
    Method Middle()
	Method Right()
	Method BreakLine()
	Method Say()

	Method NewPos()
	Method SetVPos()
	Method SetHPos()
	Method GetVPos()
	Method GetHPos()
EndClass


/*/{Protheus.doc} PrinterHelp::New
Construtor da class

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 30/11/2021

@param oParPrn, object, Instancia do FwMsPrinter
/*/
Method New(oParPrn) Class PrinterHelp
    ::oPrn := oParPrn
	::vPos := 0
	::hPos := 0
Return nil


/*/{Protheus.doc} PrinterHelp::Center
Fun��o auxiliar para centraliza��o horizontal de texto

@type Method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 30/11/2021

@param nVPxl, numeric, Posi��o vertical
@param cTexto, character, Texto a ser centralizado e impresso
@param oFont, object, Objeto com a fonte TTF para calculo de dimens�es
@param nHIni, numeric, Inicio da posi��o horizontal para centraliza��o, se vazio assumir� a posi��o atual.
@param nHFim, numeric, Fim da posi��o horizontal para centraliza��o, se vazio, assumira a largura total da pagina
@param COR, character, Cor do texto a ser impresso
/*/
Method Center(nVPxl,cTexto,oFont,nHIni,nHFim,COR) Class PrinterHelp
	Local   nLarg := ::oPrn:GetTextWidth(cTexto,oFont)
	Local   nHPos := 0
	Default nHIni := ::GetHPos()
	Default nHFim := Iif(::oPrn:GetOrientation()=1,2200,3200)
	Default COR   := nil

	// Calcula posi��o em pixel para a exibi��o
	nHPos := nHIni+Int(((nHFim-nHIni)-nLarg)/2)

	::Say(nVPxl,nHPos,cTexto,oFont,COR)
	::NewPos(nVPxl, nHIni, cTexto, oFont, ,nHFim)
Return nil


/*/{Protheus.doc} PrinterHelp::Middle
Fun��o auxiliar para centraliza��o vertital de texto

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 30/11/2021

@param nHPxl, numeric, Posi��o horizontal
@param cTexto, character, Texto a ser centralizado e impresso
@param oFont, object, Objeto com a fonte TTF para calculo de dimens�es
@param nVIni, numeric, Inicio da posi��o vertial para centraliza��o, se vazio assumir� a posi��o atual.
@param nVFim, numeric, Fim da posi��o vertical para centraliza��o, se vazio assumir� a altura total da pagina
@param COR, character, Cor do texto a ser impresso
/*/
Method Middle(nHPxl,cTexto,oFont,nVIni,nVFim,COR) Class PrinterHelp
	Local   nAlt  := ::oPrn:GetTextHeight(cTexto,oFont)
	Local   nVPos := 0
	Default nVIni := ::GetVPos()
	Default nVFim := Iif(::oPrn:GetOrientation()=1,3200,2200)
	Default COR   := nil

	// Calcula posi��o em pixel para a exibi��o
	nVPos := nVIni+Int(((nVFim-nVIni)-nAlt)/2)

	::Say(nVPos,nHPxl,cTexto,oFont,COR)
	::NewPos(nVPxl, nHIni, cTexto, oFont, nVFim)
Return aPos


/*/{Protheus.doc} PrinterHelp::BreakLine
Fun��o auxiliar para quebra de linha de textos longos

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 30/11/2021

@param cTexto, character, Texto a ser tratado
@param nLarg, numeric, Largura em pixel para acomodar o texto
@param oFont, object, Objero com a fonte TTF para calculo de dimens�es

@return array, Dados tratados para exibi��o
/*/
Method BreakLine(cTexto,nLarg,oFont) Class PrinterHelp
	Local aPalavras := Separa(AllTrim(cTexto)," ")
	Local aDados    := {}
	Local nAlt      := ::oPrn:GetTextHeight(cTexto,oFont)
	Local k         := 0
	Default nLarg   := PG_H_FIM

	If Len(aPalavras) >= 1
		aDados := {{aPalavras[1]},0}
	Else
		aDados := {{" "},0}
	Endif

	For k = 2 to Len(aPalavras)
		If ::oPrn:GetTextWidth(aDados[1,Len(aDados[1])] + aPalavras[k],oFont) > nLarg
			aAdd(aDados[1],aPalavras[k])
		Else
			aDados[1,Len(aDados[1])] += " " + aPalavras[k]
		Endif
	Next k

	aDados[2] := (nAlt + 2) * Len(aDados[1])
	If aDados[2] < 50
		aDados[2] := 50
	Endif
Return aDados


/*/{Protheus.doc} PrinterHelp::Say
Encapsulamento do Method Say para controle de posicionamento

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 13/06/2022

@param nVPxl, numeric, Posi��o vertical em Pixel, se vazio assumira a posi��o atual
@param nHPxl, numeric, Posi��o Horizontal em Pixel, se vazio assumir� a posi��o atual
@param cTexto, character, Texto a ser exibido
@param oFont, object, Fonte TTF a ser utilizada na impress�o
@param COR, character, Cor do Texto
/*/
Method Say(nVPxl, nHPxl, cTexto, oFont, COR) Class PrinterHelp
	Default nVPxl := ::GetVPos()
	Default nHPxl := ::GetHPos()

	::oPrn:Say(nVPxl,nHPxl,cTexto,oFont,,COR)
	::NewPos(nVPxl, nHPxl, cTexto, oFont)
Return nil


/*/{Protheus.doc} PrinterHelp::GetVPos
Retorna a atual posi��o vertical

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 13/06/2022

@return numeric, Posi��o vertical em Pixels
/*/
Method GetVPos() Class PrinterHelp
Return ::vPos


/*/{Protheus.doc} PrinterHelp::GetHPos
Retorna a atual posi��o horizontal

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 13/06/2022

@return numeric, Posi��o horizontal atual
/*/
Method GetHPos() Class PrinterHelp
Return ::hPos


/*/{Protheus.doc} PrinterHelp::SetVPos
Seta nova posi��o Vertical

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 13/06/2022

@param nVPxl, numeric, Nova posi��o vertical em Pixels
/*/
Method SetVPos(nVPxl) Class PrinterHelp
	::vPos := nVPxl
Return nil


/*/{Protheus.doc} PrinterHelp::SetHPos
Seta nova posi��o horizontal

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 13/06/2022

@param nHPxl, numeric, Nova posi��o horizontal em Pixels
/*/
Method SetHPos(nHPxl) Class PrinterHelp
	::hPos := nHPxl
Return nil


/*/{Protheus.doc} PrinterHelp::NewPos
Calula novas posi��es horizontais e verticais, de acordo
com texto exibido.

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 13/06/2022

@param nVPxl, numeric, Posi��o vertical em Pixels
@param nHPxl, numeric, Posi��o horizontal em Pixels
@param cTexto, character, Texto exibido
@param oFont, object, Fonte TTF utilizada na exibi��o do texto
@param nVForce, numeric, For�a que esse valor seja gravado na posi��o vertical
@param nHForce, numeric, For�a que esse valor seja gravado na posi��o horizontal
/*/
Method NewPos(nVPxl, nHPxl, cTexto, oFont, nVForce, nHForce) Class PrinterHelp
	Default nVForce := nVPxl + ::oPrn:GetTextHeight(cTexto,oFont)
	Default nHForce := nHPxl + ::oPrn:GetTextWidth(cTexto,oFont)

	::SetVPos(nVForce + PADDING)
	::SetHPos(nHForce + PADDING)
Return nil


/*/{Protheus.doc} PrinterHelp::Right
Exibe texto alinhado a direita

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 13/06/2022

@param nVPxl, numeric, Posi��o vertical em Pixel, se vazio assumira a posi��o atual
@param nHFim, numeric, Posi��o Horizontal em Pixel, se vazio assumir� a posi��o atual
@param cTexto, character, Texto a ser exibido
@param oFont, object, Fonte TTF utilizada para exibi��o
/*/
Method Right(nVPxl,nHFim,cTexto,oFont) Class PrinterHelp
	Local   nLarg := ::oPrn:GetTextWidth(cTexto,oFont)
	Local   nHPos := 0
	Default nVPxl := ::GetVPos()
	Default nHFim := PG_H_FIM

	// Calcula posi��o em pixel para a exibi��o
	nHPos := nHFim-nLarg

	::Say(nVPxl,nHPos,cTexto,oFont)
Return nil

