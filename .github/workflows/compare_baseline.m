%% This programme compares the baseline results for the FVC Fingerprint databases 
% The features used are MCC Codes, followed by KPCA
% The length of each feature vector is 1X299

clc;
clear;

%% Global Parameters
global n_sub datab n_dim;
n_sub = 100;
datab = 'FVC2004-DB1';
n_dim = 299;

%% Switch case for ease of operation
fprintf('1 For GENUINE COMPARISON\n');
fprintf('2 For IMPOSTOR COMPARISON\n');
sw = input('Enter a number: ');

switch sw

    case 1
        %% Genuine Comparison
        count = 1;
        fprintf('-------GENUINE COMPARISON-------\n');
        for num = 1:n_sub
            fprintf('Subject: %d \n',num);
            for i = 4:7
                seqone = load(strcat(pwd,'\Data\',datab,'\',num2str(num),'_',num2str(i),'.mat'));
                seq1 = seqone.Ftemplate(1,:);
                for j = i+1:8
                    seqtwo = load(strcat(pwd,'\Data\',datab,'\',num2str(num),'_',num2str(j),'.mat'));
                    seq2 = seqtwo.Ftemplate(1,:);
                    
                    % Calculate the Euclidian distance between seq1 and seq2 
                    eu_dist(count) = norm(seq1 - seq2);
                    fprintf('Euclidian Distance Between %d-%d and %d-%d is: %.5f\n',num,i,num,j,eu_dist(count));
                    count = count+1;
                end
            end
            fprintf('....done....\n');
        end
        fprintf('Average Overall Euclidian Distance Score for GENUINE mathcing is: %.5f\n',mean(eu_dist));
        genscore = 1 - eu_dist;
        filename = strcat(pwd,'\Results\',datab,'\genscore_baseline.mat');
        save(filename,'genscore');
        
    case 2
    
        %% Impostor Comparison
        clc;
        clearvars -except n_sub datab method
        count = 1;

        fprintf('-------IMPOSTOR COMPARISON-------\n');

        for num = 1:n_sub-1
            fprintf('Subject: %d \n',num);
            genbit = load(strcat(pwd,'\Data\',datab,'\',num2str(num),'_',num2str(4),'.mat'));
            seq1 = genbit.Ftemplate(1,:);
                   
            for i = num+1:n_sub
                if (i ~= num)
                    impbit = load(strcat(pwd,'\Data\',datab,'\',num2str(i),'_',num2str(4),'.mat'));
                    seq2 = impbit.Ftemplate(1,:);
                    eu_dist(count) = norm(seq1 - seq2);
                    fprintf('Euclidian Distance Between %d-%d and %d-%d is: %.5f\n',num,4,i,4,eu_dist(count));
                    count = count+1;
                end
            end
            fprintf('....done....\n');
        end
        fprintf('Average Overall Euclidian Distance for IMPOSTOR mathcing is: %.5f\n',mean(eu_dist));
        impscore = 1 - eu_dist;
        filename = strcat(pwd,'\Results\',datab,'\','impscore_baseline.mat');
        save(filename,'impscore');
        
    case 3
        
        fprintf('Wrong Choice !!\n');
end














