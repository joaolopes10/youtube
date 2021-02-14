*** Settings ***
Library           Selenium2Library
Library           Dialogs
Library           String
Variables         page_elements.py
Library           Collections

*** Variables ***
${url}            https://www.youtube.com/
${browser}        chrome
${count}          ${EMPTY}
@{title}
@{views}
@{duraction}

*** Test Cases ***
Threanding
    [Documentation]    number of views - video name - video ID
    [Setup]    Setup
    Given I navigate to Youtube trending page
    I conferm that are 50 videos
    I get the relevant data from the videos
    I find the 5 most viewed videos
    [Teardown]    close browser

*** Keywords ***
Setup
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Wait Until Element Is Visible    ${login_popup_no_tanks}
    Click Element    ${login_popup_no_tanks}
    Select Frame    ${login_popup_frame}
    Click Element    ${cookies_popup}
    Unselect Frame

I navigate to Youtube trending page
    Wait Until Element Is Visible    ${trending}
    Click Element    ${trending}
    Wait Until Page Contains Element    ${trending_list}

I conferm that are ${n_threanding} videos
    Wait Until Page Contains Element    ${trending_list}
    ${count}    Get Element Count    ${trending_list}
    Should Be True    ${count}==${n_threanding}
    log    Number of threanding videos: ${count}    warn

I get the relevant data from the videos
    FOR    ${i}    IN RANGE    1    50
        Wait Until Element Is Visible    ${trending_list}\[${i}]
        Scroll Element Into View    ${trending_list}\[${i}]
        Click Element    ${trending_list}\[${i}]
        Wait Until Element Is Visible    ${video_title}
        ${titulo}    Get Text    ${video_title}
        Append To List    ${title}    ${titulo}
        ${visualizacoes}    Get Text    ${video_views}
        ${views_convertida}    convert views    ${visualizacoes}
        Append To List    ${views}    ${views_convertida}
        ${duracao}    Get Text    ${video_duration}
        Append To List    ${duraction}    ${duracao}
        Go Back
    END

I find the 5 most viewed videos
    log    Incomplete part - To do

I skip the pub
    sleep    10s
    Run Keyword And Ignore Error    Click Element    //*[@class="ytp-ad-skip-button ytp-button"]

convert views
    [Arguments]    ${views_to_split}
    @{words}    Split String    ${views_to_split}    ${SPACE}
    ${leng}    Get Length    ${words}
    ${views_join}    Run Keyword If    ${leng}==4    Catenate    SEPARATOR=    ${words[0]}    ${words[1]}    ${words[2]}
    ...    ELSE    Catenate    SEPARATOR=    ${words[0]}    ${words[1]}
    [Return]    ${views_join}
