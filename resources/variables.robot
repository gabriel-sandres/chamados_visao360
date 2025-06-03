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
    FOR    ${linha}    IN    @{dados}
        Abrir navegador e acessar login
        Fazer login
        Aguardar leitura de QR Code
        Inserir código de autenticação
        Consultar CPF da planilha    ${linha}[CPF]
        Selecionar conta    ${linha}[Conta]
        Selecionar produto cobrança
        Abrir formulário
        Preencher campos do chamado    ${linha}
        Confirmar registro
        Capturar protocolo    ${linha}
        Fechar navegador
        Verificar se há mais chamados e reiniciar    ${linha}    ${dados}
    END
