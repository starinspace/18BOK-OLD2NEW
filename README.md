# 18BOK-OLD2NEW
Ett simpelt och litet programm med GUI för att "konvertera" äldre svenska (från cirka 1600-1910) till något mer modernt . Då äldre böcker innehåller en svenska som kan vara svår att läsa och förstå. Ord som är glömda, förlegade eller helt enkelt tappat sin betydelse idag. För att man ska kunna läsa böcker som är äldre som annars kan falla i glömska startade jag detta projekt.

## [OFFICIELL HEMSIDA](https://18bok.blogspot.com)

## Plattformar som stödjs

* Windows 7, 8, 8.1 samt 10 [Finns som [Windows Portable](https://github.com/starinspace/18BOK-OLD2NEW/releases)]
* Windows 10 [Finns som [Windows Portable](https://github.com/starinspace/18BOK-OLD2NEW/releases), som ps1-fil kräver den små justeringar]
* Linux [kräver [PowerShell 7.1+](https://docs.microsoft.com/sv-se/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1) installerat samt små justeringar i ps1-filen]
* MacOs [Kräver [PowerShell 7.1+](https://docs.microsoft.com/sv-se/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7.1) installerat samt små justeringar i ps1-filen]

## Tutorial

###
1. När du startar programmet för första gången behöver du gå till fliken "Ordboken" och klicka på "Ladda ner senaste ordboken". Du kan senare jämföra version på ordboken med online-versionen genom att klicka på "Titta ny version".
2. Konvertera en bok går du till fliken "Konvertera Bok", "Välj Bok" och välj en passande fil, klicka på "Konvertera", det här kommer ta en stund, så avsluta inte programmet före den är klar.

## Böcker/Filer programmet har som support

###
HTM, HTML, TXT. (Kommande är epub, docx)

## Skärmbild
<img src="https://1.bp.blogspot.com/-4AdiF73WQiY/YIRKpNu0e5I/AAAAAAAAE6E/0YdXnoSFSEkNZe-lzcwrl8cTQkg_XChTwCNcBGAsYHQ/s460/test.png">

## Bygg din egna fil

### 
1. Ladda ner och extrahera filerna eller via terminal: `git clone https://github.com/starinspace/18BOK-OLD2NEW.git`
2. Ladda ner [Win-PS2EXE](https://github.com/MScholtes/PS2EXE), extrahera filerna och kör programmet.
3. Välj "Source file" (ps1-filen), och välj de uppgifter som krävs och klicka på "Compile".
4. För att programmet ska funka måste du ladda ner senaste ordboken, du kan antingen göra detta i programmet under fliken "Ordboken" eller ladda ner manuellt här på github.

## Filerna

###
* Word Converter X.XX.exe (programmet)
* ord.xml (ordboken med alla orden)
* egenordbox.xml (om du lägger in egna ord, denna fil kan du även skicka till mig när du lagt in nya ord via [hemsidan](http://18bok.blogspot.se))

## Vanliga frågor
Se [FAQs](docs/faqs.md) [Ej färdig, kommer snart]

## Tack
Stort tack till er som hjälpt till att bidra med orden.

## Licens
Licens enligt [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)

