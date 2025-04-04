function readRAW
    % Run this function to connect and plot raw EEG data with UI Keyboard
    % and Text-to-Speech functionality.
    
    clear all;
    close all;
    
    data = zeros(1,256);  % Preallocate buffer
    
    % COM Port Configuration (Update if needed)
    portnum1 = 12;
    comPortName1 = sprintf('\\\\.\\COM%d', portnum1);
    
    % Constants for ThinkGear
    TG_BAUD_57600 = 57600;
    TG_STREAM_PACKETS = 0;
    TG_DATA_RAW = 4;
    TG_DATA_BLINK_STRENGTH = 37; % Blink detection

    % Load ThinkGear DLL
    loadlibrary('Thinkgear.dll');
    fprintf('Thinkgear.dll loaded\n');

    % Get connection ID handle
    connectionId1 = calllib('Thinkgear', 'TG_GetNewConnectionId');
    if connectionId1 < 0
        error('ERROR: TG_GetNewConnectionId() returned %d.\n', connectionId1);
    end

    % Connect to COM Port
    errCode = calllib('Thinkgear', 'TG_Connect', connectionId1, comPortName1, TG_BAUD_57600, TG_STREAM_PACKETS);
    if errCode < 0
        error('ERROR: TG_Connect() returned %d.\n', errCode);
    end

    fprintf('Connected. Detecting blinks...\n');

    %% UI Design
    fig = figure('Name', 'EEG Keyboard & Emergency Alert', 'NumberTitle', 'off', ...
                 'Position', [100, 100, 500, 400], 'Color', [0.8 0.9 1]);

    % Text Display for EEG-selected sentence
    uicontrol('Style', 'text', 'Position', [50 300 400 50], 'FontSize', 12, ...
              'String', 'Selected Text:', 'HorizontalAlignment', 'left');
    textBox = uicontrol('Style', 'edit', 'Position', [50 250 400 40], 'FontSize', 14, ...
                        'Enable', 'inactive', 'HorizontalAlignment', 'left');

    % Text-to-Speech Button
    uicontrol('Style', 'pushbutton', 'Position', [50 200 400 40], 'FontSize', 12, ...
              'String', 'Speak Text', 'Callback', @speakText);

    % Placeholder for Emergency Alert Button
    uicontrol('Style', 'pushbutton', 'Position', [50 150 400 40], 'FontSize', 12, ...
              'String', 'Send Emergency Alert (Placeholder)', 'Enable', 'off');

    % Keyboard Characters
    keyboardChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ ';
    selectedText = '';

    %% EEG Signal Processing & Blink Detection
    j = 0;
    i = 0;
    charIndex = 1; % Current selected character index

    while i < 10240  % Loop for 20 seconds
        if calllib('Thinkgear', 'TG_ReadPackets', connectionId1, 1) == 1
            % Read Blink Strength
            if calllib('Thinkgear', 'TG_GetValueStatus', connectionId1, TG_DATA_BLINK_STRENGTH) ~= 0
                blinkStrength = calllib('Thinkgear', 'TG_GetValue', connectionId1, TG_DATA_BLINK_STRENGTH);
                
                if blinkStrength > 50  % Blink detected
                    selectedText = [selectedText, keyboardChars(charIndex)]; % Add selected character
                    set(textBox, 'String', selectedText); % Update UI
                    charIndex = mod(charIndex, length(keyboardChars)) + 1; % Move to next character
                end
            end
        end
        
        if j == 256
            plotRAW(data);  % Plot EEG data every 0.5 seconds
            j = 0;
        end
    end

    % Disconnect from ThinkGear
    calllib('Thinkgear', 'TG_FreeConnection', connectionId1);
    fprintf('Disconnected from EEG device.\n');

    %% Function for Text-to-Speech
    function speakText(~, ~)
        storedSentence = get(textBox, 'String');
        if ~isempty(storedSentence)
            % MATLAB 2013 does not support built-in TTS, so use Windows SAPI
            system(['PowerShell -Command "Add-Type –AssemblyName System.Speech; ', ...
                    '$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; ', ...
                    '$speak.Speak(''', storedSentence, ''')"']);
        else
            msgbox('No text selected!', 'Warning', 'warn');
        end
    end
end
