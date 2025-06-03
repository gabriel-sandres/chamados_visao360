*** Settings ***
Library    SeleniumLibrary
Library    RPA.Excel.Files
Library    OperatingSystem
Library    Collections
Library    DotEnv
Resource   variables.robot
Resource   locators.robot

*** Keywords ***

Carregar .env
    Load Environment Variables    .env

Abrir navegador e acessar login
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window

Fazer login
    Input Text    ${LOGIN_USERNAME}    ${USERNAME}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Button    ${LOGIN_BUTTON}

Aguardar leitura de QR Code
    Wait Until Element Is Visible    ${QR_CODE}
    Pause Execution    Escaneie o QR code e clique em OK quando estiver validado.

Inserir código de autenticação
    Wait Until Element Is Visible    ${CODE_INPUT}
    ${codigo}=    Get Value From User    Digite o código de autenticação recebido:
    Input Text    ${CODE_INPUT}    ${codigo}
    Click Button    ${VALIDATE_BUTTON}

Abrir planilha
    Open Workbook    ${EXCEL_PATH}

Fechar planilha
    Close Workbook

Carregar linhas pendentes
    ${linhas}=    Read Worksheet As Table    header=True
    ${pendentes}=    Create List
    FOR    ${linha}    IN    @{linhas}
        ${protocolo}=    Get From Dictionary    ${linha}    Protocolo Visão    default=None
        Run Keyword If    '${protocolo}' == '' or '${protocolo}' == 'nan'    Append To List    ${pendentes}    ${linha}
    END
    Set Suite Variable    ${pendentes}

Registrar chamado do cooperado
    [Arguments]    ${linha}
    Go To    ${BASE_URL}
    Wait Until Element Is Visible    ${CPF_INPUT}
    Input Text    ${CPF_INPUT}    ${linha}[Documento do cooperado]
    Click Element    ${BTN_CONSULTAR}
    Sleep    2s

    # Simular preenchimento do formulário — ajuste os XPaths conforme necessário
    Log    Selecionando conta e abrindo formulário...
    Sleep    1s
    Log    Preenchendo formulário para: ${linha}[Categoria] / ${linha}[Serviço]
    Sleep    1s
    Log    Clicando em Registrar e Confirmar
    Sleep    1s

    ${protocolo}=    Generate Random String    10    [NUMBERS]
    Set To Dictionary    ${linha}    Protocolo Visão=${protocolo}

    Log    Protocolo gerado: ${protocolo}

Atualizar planilha com protocolos
    [Arguments]    ${linhas}
    Write Worksheet From Table    ${linhas}    header=True
    Save Workbook
