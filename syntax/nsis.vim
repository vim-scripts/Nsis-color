" Vim syntax file
" Language:     Nullsoft install system .nsi script syntax (v1.96)
" Maintainer:   Artem Zankovich <az@ring.by>
" Last Change:  6 Apr 2002

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syn case ignore

" Numbers
syn match   nsiNumber           "\<\d\+\>"
syn match   nsiNumber           "\<0x\x\+\>"
syn match   nsiNumber           "\<0\o\+\\>"

" Strings
syn region  nsiString           start=+"+me=e-1  end=+"+ end=+[^\\]\s*$+ contains=nsiVar1 contained
syn region  nsiString           start=+'+me=e-1  end=+'+ end=+[^\\]\s*$+ contains=nsiVar1 contained
syn region  nsiStringDex        start=+"+me=e-1  end=+"+ end=+[^\\]\s*$+ contained
syn region  nsiStringDex        start=+'+me=e-1  end=+'+ end=+[^\\]\s*$+ contained
syn region  nsiStringEx         start=+"+me=e-1  end=+"+ end=+[^\\]\s*$+ contains=nsiVar1,nsiVar2 contained
syn region  nsiStringEx         start=+'+me=e-1  end=+'+ end=+[^\\]\s*$+ contains=nsiVar1,nsiVar2 contained

" Variables
syn match   nsiVar1             "\$R\=\d" contained
syn match   nsiVar1             "\$\\[nr]" contained
syn match   nsiVar1             "\${\w\+}" contained
syn match   nsiVar2             "\$\(INSTDIR\|OUTTDIR\|PROGRAMFILES\|DESKTOP\|EXEDIR\|WINDIR\|SYSDIR\|TEMP\|STARTMENU\|SMPROGRAMS\|SMSTARTUP\|QUICKLAUNCH\|HWNDPARENT\|CMDLINE\|\$\)" contained

syn cluster nsiSingle           contains=nsiComment,nsiString,nsiNumber,nsiVar1
syn cluster nsiComplex          contains=nsiComment,nsiStringEx,nsiNumber,nsiVar1,nsiVar2

" Labels
syn match   nsiLabel           "^\s*.\=\w\+[\w\d\-]*\:"


" Compiler utility commands
syn region  nsiDirective        matchgroup=nsiDirective start="^\s*\!\(system\|include\|cd\|packhdr\)\>" end="$"  skip="\\$" contains=nsiComment,nsiStringDex,nsiNumber keepend
" Compiler defines/conditional compilation
syn region  nsiDirective        matchgroup=nsiDirective start="^\s*\!\(define\|undef\|ifdn\=ef\|ifndef\|endif\|\(else\sifn\=def\)\|else\|macro\|macroend\|insertmacro\)\>" end="$"  skip="\\$" contains=nsiComment,nsiStringDex,nsiNumber keepend


" Compiler flags
syn keyword nsiFlag             on off try ifnewer auto force contained
syn region  nsiFlags            matchgroup=nsiStatement start="^\s*Set\(Overwrite\|Compress\|DatablockOptimize\|DateSave\)\>" end="$"  skip="\\$" contains=@nsiSingle,nsiFlag keepend

" Sections
syn region  nsiFS               matchgroup=nsiStatement start="^\s*SectionDivider\>" end="$"  skip="\\$" contains=nsiStringDex keepend
syn region  nsiFS               matchgroup=nsiStatement start="^\s*Section\>"  end="$"  skip="\\$" contains=nsiStringDex,nsiSectUninstall keepend
syn region  nsiStatement        matchgroup=nsiStatement start="\(SectionIn\|AddSize\)" end="$"  skip="\\$" contains=@nsiSingle keepend
" Functions
syn region  nsiFS               matchgroup=nsiStatement start="^\s*Function\>"  end="$"  skip="\\$" contains=nsiStringDex,nsiCallback keepend

syn region  nsiStatement        matchgroup=nsiStatement start="\(FunctionEnd\|SectionEnd\)" end="$"  skip="\\$" keepend

" Installer attributes
syn keyword nsiAttribute       on off normal silent silentlog show hide nevershow true false contained
"  General installer configuration
syn region  nsiAttributes       matchgroup=nsiStatement start="^\s*\(OutFile\|Name\|Caption\|SubCaption\|BrandingText\|Icon\|WindowIcon\|BGGradient\|SilentInstall\|SilentUnInstall\|CRCCheck\|MiscButtonText\|InstallButtonText\|FileErrorText\)" end="$"  skip="\\$" contains=@nsiSingle,nsiAttribute  keepend
"  Install directory configuration
syn region  nsiAttributes       matchgroup=nsiStatement start="^\s*InstallDir\>"  end="$"  skip="\\$" contains=@nsiComplex keepend
syn region  nsiAttributes       matchgroup=nsiStatement start="^\s*\(InstallDirRegKey\)\>" end="$"  skip="\\$" contains=@nsiSingle keepend
"  License page configuration
syn region  nsiAttributes       matchgroup=nsiStatement start="^\s*\(LicenseText\|LicenseData\)\>" end="$"  skip="\\$" contains=@nsiSingle  keepend
"  Component page configuration
syn region  nsiAttributes       matchgroup=nsiStatement start="^\s*\(ComponentText\|InstType\|EnabledBitmap\|DisabledBitmap\|SpaceTexts\)\>" end="$"  skip="\\$" contains=@nsiSingle  keepend
"  Directory page configuration
syn region  nsiAttributes       matchgroup=nsiStatement start="^\s*\(DirShow\|DirText\|AllowRootDirInstall\)\>" end="$"  skip="\\$" contains=@nsiSingle,nsiAttribute  keepend
"  Install page configuration
syn region  nsiAttributes       matchgroup=nsiStatement start="^\s*\(InstallColors\|InstProgressFlags\|AutoCloseWindow\|ShowInstDetails\|DetailsButtonText\|CompletedText\)\>" end="$" skip="\\$" contains=@nsiSingle,nsiAttribute  keepend
"  Uninstall configuration
syn region  nsiAttributes       matchgroup=nsiStatement start="^\s*\(UninstallText\|UninstallIcon\|UninstallCaption\|UninstallSubCaption\|ShowUninstDetails\|UninstallButtonText\)\>" end="$"  skip="\\$" contains=@nsiSingle,nsiAttribute  keepend

" Instructions
"  General purpose, basic instructions
syn region  nsiInstructions     matchgroup=nsiStatement start="\<\(SetOutPath\|File\|\(Exec\(Wait\|Shell\)\=\)\|Rename\|Delete\|RMDir\)\>" end="$"  skip="\\$" contains=@nsiComplex keepend
"  Registry, INI file reading/writing/deleting instructions
syn region  nsiInstructions     matchgroup=nsiStatement start="\(WriteReg\(Str\|ExpandStr\|DWORD\|Bin\)\|ReadReg\(Str\|DWORD\)\|DeleteReg\(Value\|Key\)\|EnumReg\(Key\|Value\)\)\>" end="$"  skip="\\$" contains=@nsiComplex,nsiRegRootKey keepend
syn region  nsiInstructions     matchgroup=nsiStatement start="\(WriteINIStr\|ReadINIStr\|ReadEnvStr\|ExpandEnvStrings\|DeleteINISec\|DeleteINIStr\)\>" end="$"  skip="\\$" contains=@nsiComplex keepend
"  General purpose, advanced instructions
syn region  nsiInstructions     matchgroup=nsiStatement start="\(CreateDirectory\|CopyFiles\|SetFileAttributes\|CreateShortCut\|\|GetTempFileName\|CallInstDLL\|RegDLL\|UnRegDLL\|GetFullPathName\|SearchPath\|GetDLLVersion\|GetDLLVersionLocal\|GetFileTime\|GetFileTimeLocal\|Nop\)\>" end="$"  skip="\\$" contains=@nsiComplex keepend
"  Branching, flow control, error checking, user interaction, etc instructions
syn region  nsiInstructions     matchgroup=nsiStatement start="\(Goto\|Call\|Return\|IfErrors\|ClearErrors\|\|SetErrors\|FindWindow\|SendMessage\|IsWindow\|IfFileExists\|StrCmp\|IntCmp\|IntCmpU\|Abort\|Quit\|GetFunctionAddress\|GetLabelAddress\|GetCurrentAddress\)\>" end="$"  skip="\\$" contains=@nsiComplex keepend
syn region  nsiInstructions     matchgroup=nsiStatement start="Messagebox\>" end="$"  skip="\\$" contains=@nsiComplex,nsiMBk keepend
"  File and directory i/o instructions
syn region  nsiInstructions     matchgroup=nsiStatement start="\(FindFirst\|FindNext\|FindClose\|FileOpen\|FileClose\|FileRead\|FileWrite\|FileReadByte\|FileWriteByte\|FileSeek\)\>" end="$"  skip="\\$" contains=@nsiComplex keepend
"  Misc instructions
syn region  nsiInstructions     matchgroup=nsiStatement start="\(SetDetailsView\|SetDetailsPrint\|SetAutoClose\|DetailPrint\|Sleep\|BringToFront\|HideWindow\|StrCpy\|StrLen\|Push\|Pop\|Exch\|IntOp\|IntFmt\)\>" end="$"  skip="\\$" contains=@nsiComplex keepend
"  Rebooting support
syn region  nsiInstructions     matchgroup=nsiStatement start="\(Reboot\|IfRebootFlag\|SetRebootFlag\)\>" end="$"  skip="\\$" contains=@nsiComplex keepend
"  Uninstaller instructions
syn region  nsiInstructions     matchgroup=nsiStatement start="\(WriteUninstaller\)\>" end="$"  skip="\\$" contains=@nsiComplex keepend



" In section
syn region  nsiSect             matchgroup=nsiStatement start="\(SectionIn\|AddSize\)\>" end="$"  skip="\\$" contains=@nsiComplex keepend

" Callback functions
"  Install callbacks
syn match   nsiCallback         "\.\(onInit\|onUserAbort\|onInstSuccess\|onInstFailed\|onVerifyInstDir\|onNextPage\|onPrevPage\)\>" contained
"  Uninstall callbacks
syn match   nsiCallback         "un\.\(onInit\|onUserAbort\|onUninstSuccess\|onUninstFailed\|onNextPage\)\>" contained

syn keyword nsiRegRootKey       HKCR HKEY_CLASSES_ROOT HKLM HKEY_LOCAL_MACHINE HKCU HKEY_CURRENT_USER HKU HKEY_USERS HKCC HKEY_CURRENT_CONFIG HKDD HKEY_DYN_DATA HKPD HKEY_PERFORMANCE_DATA contained
syn keyword nsiMBk              MB_OK MB_OKCANCEL MB_ABORTRETRYIGNORE MB_RETRYCANCEL MB_YESNO MB_YESNOCANCEL MB_ICONEXCLAMATION MB_ICONINFORMATION MB_ICONQUESTION MB_ICONSTOP MB_TOPMOST MB_SETFOREGROUND MB_RIGHT MB_DEFBUTTON1 MB_DEFBUTTON2 MB_DEFBUTTON3 MB_DEFBUTTON4 contained
syn keyword nsiMBk              IDABORT IDCANCEL IDIGNORE IDNO IDOK IDRETRY IDYES contained
syn keyword nsiSectUninstall    Uninstall contained

syn keyword nsiTodo             TODO contained
syn match   nsiComment          "#.*$" oneline contains=nsiTodo
syn match   nsiComment          ";.*$" oneline contains=nsiTodo


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_nsi_syn_inits")
    if version < 508
        let did_nsi_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
        command -nargs=+ Hi     hi <args>
    else
        command -nargs=+ HiLink hi def link <args>
        command -nargs=+ Hi     hi def <args>
    endif

    HiLink  nsiComment          Comment
    HiLink  nsiNumber           Number
    HiLink  nsiLabel            Label
    HiLink  nsiFS               Normal
    HiLink  nsiFunc             Normal
    HiLink  nsiSect             Normal
    HiLink  nsiString           String
    HiLink  nsiStringEx         String
    HiLink  nsiStringDex        String
    HiLink  nsiDirective        PreProc
    HiLink  nsiFlags            Normal
    HiLink  nsiAttributes       Normal
    HiLink  nsiInstructions     Normal
    HiLink  nsiCallback         Identifier
    HiLink  nsiSectUninstall    Identifier
    HiLink  nsiError            Error
    HiLink  nsiStatement        Statement
    HiLink  nsiInstruction      Special
    HiLink  nsiVar1             Special
    HiLink  nsiVar2             Special
    HiLink  nsiMBk              Special
    HiLink  nsiRegRootKey       Special
    HiLink  nsiAttribute        Special
    HiLink  nsiFlag             Special
    HiLink  nsiTodo             Todo

    delcommand HiLink
    delcommand Hi
endif

let b:current_syntax = "nsi"

" vim: ts=8
