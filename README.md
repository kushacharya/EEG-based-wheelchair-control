# EEG-Based Wheelchair Control System

This project is focused on developing a wheelchair control system that uses EEG signals to assist people with physical disabilities. The system uses eye blinks detected from EEG data to control the direction of the wheelchair and to support communication with caretakers.

## Project Features

- Blink detection using EEG signals
- Direction control based on blink confirmation
- A virtual keyboard that allows the user to type messages using blinks
- Text-to-speech system to speak out the typed message
- SMS alert system for communication with caretakers in emergency situations

## Tools and Technologies Used

- MATLAB for signal processing
- Python for user interface and communication features
- Arduino for hardware control and motor movement
- EEG headset (OpenBCI, NeuroSky, or Arduino-based sensors)


## How the System Works

1. EEG headset collects brain signals in real time.
2. MATLAB filters and processes the EEG data to detect blinks.
3. A direction selection interface cycles through options (Forward, Right, Backward, Left).
4. The user confirms the selected direction by blinking at the right moment.
5. The command is sent to an Arduino which moves the wheelchair.
6. A virtual keyboard allows users to type using blinks.
7. Typed messages can be spoken out using text-to-speech or sent as SMS.

## Goals

- To make mobility easier for people with severe physical limitations
- To provide a low-cost, accessible solution using open tools
- To support both movement and communication in a simple system

## License

This project is open source under the MIT License.

## Acknowledgements

- Nirma University for project support  
- Our project guide for technical help  
- Open-source EEG and assistive tech communities
