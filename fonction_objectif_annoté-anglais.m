%% Approximation of the non-linear objective function

clear all;
Data_plants(1,:)={"fraise",120,10,20,30,20,}; %strawberry      
Data_plants(2,:)={"radis",230,20,21,10,10,}; %radish      
Data_plants(3,:)={"roquette",150,42,26,40,20,}; %arugula    
Data_plants(4,:)={"laitue",400,35,50,52,23,}; %letuce       
Data_plants(5,:)={"piment",100,51,50,20,15,}; %pepper 
Data_plants(6,:)={"épinard",170,21,12,40,10,}; %spinach       
Data_plants(7,:)={"basilic",80,12,10,10,50,}; %basil       
[ligne,colonne]=size(Data_plants);  
division=[];
sol=[];
%establish the descreasing order of the plants in function if the calries/time ratio. 
for n= 1:ligne
   division(n)=Data_plants{n,2}/(Data_plants{n,3}+Data_plants{n,4}+Data_plants{n,5}+Data_plants{n,6});
end
%looking for a and b to obtain the same order than the non linear function 
[divmax,idivmax]=max(division);
for a = 0 : 1 : 10
    for b = 0: 1 : 10
        for n= 1:ligne
   soustraction(n)=a*Data_plants{n,2}-b*(Data_plants{n,3}+Data_plants{n,4}+Data_plants{n,5}+Data_plants{n,6});
        end
        [soumax,isoumax]=max(soustraction);
        if (isoumax==idivmax)
           sol=[sol,a,b]; 
        end
    end
end