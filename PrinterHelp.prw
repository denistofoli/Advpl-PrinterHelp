#Include "Totvs.ch"
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

    Method New()
    Method Center()
    Method Middle()
	Method BreakLine()
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
	Local   nLarg := 0
	Local   nHPos := 0
	Default nHIni := 0
	Default nHFim := Iif(::oPrn:GetOrientation()=1,2200,3200)
	Default COR   := nil

	// Largura do Texto
	nLarg := ::oPrn:GetTextWidth(cTexto,oFont)

	// Calcula posição em pixel para a exibição
	nHPos := nHIni+Int(((nHFim-nHIni)-nLarg)/2)

	::oPrn:Say(nVPxl,nHPos,cTexto,oFont,,COR)
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
	Local   nAlt  := 0
	Local   nVPos := 0
	Default nVIni := 0
	Default nVFim := Iif(::oPrn:GetOrientation()=1,3200,2200)
	Default COR   := nil

	// Largura do Texto
	nAlt := ::oPrn:GetTextHeight(cTexto,oFont)

	// Calcula posição em pixel para a exibição
	nVPos := nVIni+Int(((nVFim-nVIni)-nAlt)/2)

	::oPrn:Say(nVPos,nHPxl,cTexto,oFont,,COR)
Return nil


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

	// TODO Imprimir ao invés de devolver os dados
Return aDados
