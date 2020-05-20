%% This programme compares the anonymization results for the FVC Fingerprint databases 
% The features used are MCC Codes, followed by KPCA
% The length of each feature vector is 1X299

clc;
clear;

%% Global Parametersb
global n_sub datab n_dim k qi;
n_sub = 100;
datab = 'FVC2002-DB1';
n_dim = 299;
qi = 25;
k = 30;

%% Switch case for ease of operation
fprintf('1 For GENUINE COMPARISON\n');
fprintf('2 For IMPOSTOR COMPARISON\n');
sw = input('Enter a number: ');

switch sw

    case 1
        %% Genuine Comparison
        count = 1;
        fprintf('-------GENUINE COMPARISON-------\n');
        % Load the CSV file
        filenametable = strcat(pwd,'\Anon\',datab,'\',num2str(qi),'_',num2str(k),'.csv');
        Untitled =  table2array(readtable(filenametable,'HeaderLines',1));
                
        for num = 1:n_sub
            fprintf('Subject: %d \n',num);
            seq1 = Untitled(num,:);   % The sample in the anonymization table
            for i = 5:8
                seq = load(strcat(pwd,'\Data\',datab,'\',num2str(num),'_',num2str(i),'.mat'));
                seq2 = seq.Ftemplate(1,:);
                % Calculate the Euclidian distance between seq1 and seq2 
                eu_dist(count) = norm(seq1 - seq2);
                fprintf('Euclidian Distance Between %d-%d and %d-%d is: %.5f\n',num,4,num,i,eu_dist(count));
                count = count+1;
            end
            fprintf('....done....\n');
        end
        fprintf('Average Overall Euclidian Distance Score for GENUINE mathcing is: %.5f\n',mean(eu_dist));
        genscore = 1 - eu_dist;
        filename = strcat(pwd,'\Results\',datab,'\genscore_',num2str(qi),'_',num2str(k),'.mat');
        save(filename,'genscore');
        
    case 2
    
        %% Impostor Comparison
        clc;
        clearvars -except n_sub datab method qi k
        count = 1;

        fprintf('-------IMPOSTOR COMPARISON-------\n');
        % Load the CSV file
        filenametable = strcat(pwd,'\Anon\',datab,'\',num2str(qi),'_',num2str(k),'.csv');
        Untitled =  table2array(readtable(filenametable,'HeaderLines',1));

        for num = 1:n_sub-1
            fprintf('Subject: %d \n',num);
            seq1 = Untitled(num,:);   % The sample in the anonymization table
            for i = num+1:n_sub
                if (i ~= num)
                    impbit = load(strcat(pwd,'\Data\',datab,'\',num2str(i),'_',num2str(5),'.mat'));
                    seq2 = impbit.Ftemplate(1,:);
                    eu_dist(count) = norm(seq1 - seq2);
                    fprintf('Euclidian Distance Between %d-%d and %d-%d is: %.5f\n',num,4,i,5,eu_dist(count));
                    count = count+1;
                end
            end
            fprintf('....done....\n');
        end
        fprintf('Average Overall Euclidian Distance for IMPOSTOR mathcing is: %.5f\n',mean(eu_dist));
        impscore = 1 - eu_dist;
        filename = strcat(pwd,'\Results\',datab,'\impscore_',num2str(qi),'_',num2str(k),'.mat');
        save(filename,'impscore');
        
    case 3
        
        fprintf('Wrong Choice !!\n');
end














