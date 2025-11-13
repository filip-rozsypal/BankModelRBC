



% matlab
set(0, 'DefaultFigureVisible', 'on');
set(groot,'DefaultFigureWindowStyle','docked') ;
clc;

for i_fig = 1:50
    figure(i_fig);
    close;
end




switch USER
    case 'Filip'
        FOLDER.work = '~/Dropbox/policy/bank_model/dynare_testing/';
    case 'Rasmus'
        error('running folder not defined')
    case 'Emil'
        error('running folder not defined')        
    case 'Jens'
        error('running folder not defined')        
end

FOLDER.base = cd; 

cd(FOLDER.work); % move to the work directory

% copy files
source = [FOLDER.base,'/',DATA];
destination = [FOLDER.work,'/',DATA];
status = copyfile(source,destination);
if status == 0
    error('copying of ',source,' not successful');
end

source = [FOLDER.base,'/',MODEL];
destination = [FOLDER.work,'/',MODEL];
copyfile(source,destination);
if status == 0
    error('copying of ',source,' not successful');
end

eval(['dynare ',MODEL]); % run dynare

cd(FOLDER.base); % move back

