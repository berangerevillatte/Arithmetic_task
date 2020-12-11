# Arithmetic_task

# Authors 
Bérangère Villatte <berangere.villatte@umontreal.ca> and Charlotte Bigras <charlotte.bigras@umontreal.ca>

# Content 
Arithmetic task developped for the PSY6976 course, Université de Montréal, 2020.
Silent task of mental calculation by visual display inducing psychological stress.

This task will be used for the AUDACE project which is scheduled to run from January 2021 to June 2021 in the Hébert lab at the School of Speech-Language Pathology and Audiology of the University of Montreal.

# Objective
The objective of this task is to induce psychological stress via:
maximum response time
memorization
elapsed time progress bar
negative feedback if an error is made or if time is up

# Prerequisites
Before starting the task, you must 
1. Enter participant code
2. Indicate whether the user is using a Mac operating system (yes or no)
3. Select the duration of the task (set to 300 sec (5min) by default).

The default values of the main variables are as follows, but can be changed:
startCount = 1022; % Starting number for arithmetic task
subtract = 13; % step size subtraction
trialTout = 7.5; % max time allocated per trial

The task can only run with the arithTrials function, which includes the response input loop, feedback loop and the printTimer function that allows you to display visually the elapsed time for each equation.

# Methods
The task requires the participant to perform a series of subtractions, always from the same number within a set time frame for each equation.
The participant must enter the numeric answer using the keypad and press Enter. The answer will be displayed on the screen. The participant can also erase the answer if they make a mistake during a trial. To exit the task before the end, the participant can press the Escape key and will be returned to the command window.
If a mistake is made or if the allotted time has elapsed, the participant must start over at the starting equation. The purpose of this task is to induce mental stress to the participant while recording his or her biosignals(e.g. heart rate).
Only the first equation will be displayed (startCount - subtract). The participant must remember their previous answer and  continue to subtract the subtract value from this number until they make a mistake or the trialTout is up.

# Recording of data
Data recorded in .xlsx in a DATA folder: "Step" (= 1 for the first equation), "Accuracy" (0 or 1), partResp (numerical response given by the participant) and "RT" (reaction time per response).

# References 

This task was inspired by two mental arithmetic tasks used to induce mental stress in experimental research: the TSST and MIST.

TSST: Birkett, M. A. (2011). The Trier Social Stress Test protocol for inducing psychological stress. Journal of Visualized Experiments. https://doi.org/10.3791/3238

MIST: Dedovic, K., Renwick, R., Mahani, N. K., Engert, V., Lupien, S. J., & Pruessner, J. C. (2005). The Montreal Imaging Stress Task: Using functional imaging to investigate the effects of perceiving and processing psychosocial stress in the human brain. Journal of Psychiatry and Neuroscience.
