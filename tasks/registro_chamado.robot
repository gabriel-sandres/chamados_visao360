*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    ExcelLibrary.robot

*** Variables ***
${BROWSER}            chrome
${BASE_URL}           https://portal.sisbr.coop.br/visao360/consult
${LOGIN_URL}          https://portal.sisbr.coop.br/auth/realms/sisbr/protocol/openid-connect/auth?&scope=openid&client_id=visao360-sisbr&response_type=code&redirect_uri=${BASE_URL}
${USERNAME}           %{USERNAME}
${PASSWORD}           %{PASSWORD}
${EXCEL_PATH}         ./input/planilha_registro.xlsx
${LOGIN_USERNAME}     //*[@id="username"]
${LOGIN_PASSWORD}     //*[@id="password"]
${LOGIN_BUTTON}       //*[@id="kc-login"]
${QR_CODE}            //*[@id="qr-code"]
${CODE_INPUT}         //*[@id="code"]
${VALIDATE_BUTTON}    //*[@id="login"]/div[3]/button[1]
${CPF_INPUT}          //*[@id="app"]/section/sc-content/sc-consult/div/div[2]/div/sc-card-content/div/main/form/div/div[2]/sc-form-field/div/input
${CONSULTAR_BTN}      //*[@id="app"]/section/sc-content/sc-consult/div/div[2]/div/sc-card-content/div/main/form/div/div[3]/sc-button/button
${ABRIR_BTN}          //*[@id="app"]/section/sc-content/sc-consult/div/div[2]/div/sc-card-content/div/main/form/div/div[4]/sc-card/div/sc-card-content/div/div/div[2]/sc-button/button
${CONTA_SELECT}       //*[@id="accounts"]
${PRODUTO_COBRANCA}   //*[@id="products"]/div[10]/sc-card/div/div/div/div
${BTN_FORMULARIO}     //button[@tooltip='Registro de chamado']
${TIPO_ATENDIMENTO}   //*[@id="serviceTypeId"]
${CATEGORIA}          //*[@id="categoryId"]
${SUBCATEGORIA}       //*[@id="subCategoryId"]
${SERVICO}            //*[@id="serviceId"]
${CANAL}              //*[@id="Canal De Autoatendimento"]
${PROTOCOLO_PLAD}     //*[@id="Protocolo Plad"]
${DESCRICAO}          //*[@id="description"]
${REGISTRAR_BTN}      //*[@id="actionbar hide"]/div/div[2]/form/div/div[20]/sc-button/button
${CONFIRMAR_REGISTRAR_BTN}    //*[@id="modal"]/div/sc-modal-footer/div/div/div[2]/sc-button/button
${PROTOCOLO_GERADO}   //*[@id="actionbar hide"]/div/div[2]/form/div/div[2]/sc-card/div/sc-card-content/div/div/div[1]/h5

*** Test Cases ***
Registrar Todos Chamados Visão360
    ${dados}=    Ler Planilha Excel    ${EXCEL_PATH}
    :FOR    ${linha}    IN    @{dados}
    \    Abrir navegador e acessar login
    \    Fazer login
    \    Aguardar leitura de QR Code
    \    Inserir código de autenticação
    \    Consultar CPF da planilha    ${linha}[CPF]
    \    Selecionar conta    ${linha}[Conta]
    \    Selecionar produto cobrança
    \    Abrir formulário
    \    Preencher campos do chamado    ${linha}
    \    Confirmar registro
    \    Capturar protocolo    ${linha}
    \    Fechar navegador
    \    Recarregar se necessário

*** Keywords ***
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
    Input Text    ${CODE_INPUT}    1234
    Click Button    ${VALIDATE_BUTTON}

Consultar CPF da planilha
    [Arguments]    ${cpf}
    Wait Until Element Is Visible    ${CPF_INPUT}
    Input Text    ${CPF_INPUT}    ${cpf}
    Click Button    ${CONSULTAR_BTN}
    Wait Until Element Is Enabled    ${ABRIR_BTN}
    Click Button    ${ABRIR_BTN}

Selecionar conta
    [Arguments]    ${conta}
    Select From List By Label    ${CONTA_SELECT}    ${conta}

Selecionar produto cobrança
    Click Element    ${PRODUTO_COBRANCA}
    Wait Until Page Contains Element    //div[contains(@class,"selected-product")]

Abrir formulário
    Click Element    ${BTN_FORMULARIO}

Preencher campos do chamado
    [Arguments]    ${linha}
    Input Text    ${TIPO_ATENDIMENTO}    Chat Receptivo
    Input Text    ${CATEGORIA}    ${linha}[Categoria]
    Input Text    ${SUBCATEGORIA}    Api Sicoob
    Input Text    ${SERVICO}    ${linha}[Servico]
    Select From List By Label    ${CANAL}    Não Se Aplica
    Input Text    ${PROTOCOLO_PLAD}    ${linha}[Protocolo]
    ${descricao}=    Set Variable If    '${linha}[Descricao]' and len('${linha}[Descricao]') > 10    ${linha}[Descricao]    Chamado da Plataforma de atendimento digital registrado via automação
    Input Text    ${DESCRICAO}    ${descricao}

Confirmar registro
    Click Button    ${REGISTRAR_BTN}
    Click Button    ${CONFIRMAR_REGISTRAR_BTN}

Capturar protocolo
    [Arguments]    ${linha}
    ${protocolo}=    Get Text    ${PROTOCOLO_GERADO}
    Log    Protocolo gerado: ${protocolo}
    # Aqui você pode salvar na planilha com uma função customizada se desejar

Fechar navegador
    Close Browser

Recarregar se necessário
    # Esse bloco simula a verificação de mais linhas no FOR e recarrega URL se necessário
    # Como já estamos iterando com FOR, o recarregamento do navegador será automático a cada loop
