#Include "Totvs.ch"

#Define PADDING 2
#Define PG_H_INI 0000
#Define PG_H_FIM 2300

/*/{Protheus.doc} PrinterHelp
Classe utilitária para ajudar na construção de 
relatório gráficos com FwMsPrinter.

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
Função auxiliar para centralização horizontal de texto

@type Method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 30/11/2021

@param nVPxl, numeric, Posição vertical
@param cTexto, character, Texto a ser centralizado e impresso
@param oFont, object, Objeto com a fonte TTF para calculo de dimensões
@param nHIni, numeric, Inicio da posição horizontal para centralização
@param nHFim, numeric, Fim da posição horizontal para centralização
@param COR, character, Cor do texto a ser impresso
/*/
Method Center(nVPxl,cTexto,oFont,nHIni,nHFim,COR) Class PrinterHelp
	Local   nLarg := ::oPrn:GetTextWidth(cTexto,oFont)
	Local   nHPos := 0
	Default nHIni := ::GetVPos()
	Default nHFim := Iif(::oPrn:GetOrientation()=1,2200,3200)
	Default COR   := nil

	// Calcula posição em pixel para a exibição
	nHPos := nHIni+Int(((nHFim-nHIni)-nLarg)/2)

	::Say(nVPxl,nHPos,cTexto,oFont,COR)
	::NewPos(nVPxl, nHIni, cTexto, oFont, ,nHFim)
Return nil


/*/{Protheus.doc} PrinterHelp::Middle
Função auxiliar para centralização vertital de texto

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 30/11/2021

@param nHPxl, numeric, Posição horizontal
@param cTexto, character, Texto a ser centralizado e impresso
@param oFont, object, Objeto com a fonte TTF para calculo de dimensões
@param nVIni, numeric, Inicio da posição vertial para centralização
@param nVFim, numeric, Fim da posição vertical para centralização
@param COR, character, Cor do texto a ser impresso
/*/
Method Middle(nHPxl,cTexto,oFont,nVIni,nVFim,COR) Class PrinterHelp
	Local   nAlt  := ::oPrn:GetTextHeight(cTexto,oFont)
	Local   nVPos := 0
	Default nVIni := ::GetVPos()
	Default nVFim := Iif(::oPrn:GetOrientation()=1,3200,2200)
	Default COR   := nil

	// Calcula posição em pixel para a exibição
	nVPos := nVIni+Int(((nVFim-nVIni)-nAlt)/2)

	::Say(nVPos,nHPxl,cTexto,oFont,COR)
	::NewPos(nVPxl, nHIni, cTexto, oFont, nVFim)
Return aPos


/*/{Protheus.doc} PrinterHelp::BreakLine
Função auxiliar para quebra de linha de textos longos

@type method
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 30/11/2021

@param cTexto, character, Texto a ser tratado
@param nLarg, numeric, Largura em pixel para acomodar o texto
@param oFont, object, Objero com a fonte TTF para calculo de dimensões

@return array, Dados tratados para exibição
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

Method Say(nVPxl, nHPxl, cTexto, oFont, COR) Class PrinterHelp
	Default nVPxl := ::GetVPos()
	Default nHPxl := ::GetHPos()

	::oPrn:Say(nVPxl,nHPxl,cTexto,oFont,,COR)
	::NewPos(nVPxl, nHPxl, cTexto, oFont)
Return nil

Method GetVPos() Class PrinterHelp
Return ::vPos

Method GetHPos() Class PrinterHelp
Return ::hPos

Method SetVPos(nVPxl) Class PrinterHelp
	::vPos := nVPxl
Return nil

Method SetHPos(nHPxl) Class PrinterHelp
	::hPos := nHPxl
Return nil


Method NewPos(nVPxl, nHPxl, cTexto, oFont, nVForce, nHForce) Class PrinterHelp
	Default nVForce := nVPxl + ::oPrn:GetTextHeight(cTexto,oFont)
	Default nHForce := nHPxl + ::oPrn:GetTextWidth(cTexto,oFont)

	::vPos := nVForce + PADDING
	::hPos := nHForce + PADDING
Return nil

