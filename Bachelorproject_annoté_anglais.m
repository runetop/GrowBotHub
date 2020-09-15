clear all;
%% Bachelor Projet - scheduling of vegetables growth - 
%matrix containing moving hours: the ligh corresponds to the number of the 
%plant. The rows represent the hours of entry in the shelves and the harvest hour 

Plantschange=[[0, 10, 30, 60, 80]; [0, 10, 30, 60, 80]; [0, 10, 30, 60, 80]; [0, 10, 30, 60, 80]; [0, 10, 30, 61, 81]; [0, 10, 30, 80, 100]; [0, 10, 30, 60, 80]; [157, 209, 249, 259, 269]; [197, 217, 238, 248, 258]; [10, 30, 70, 80, 90]; [10, 30, 51, 61, 71]; [10, 30, 60, 71, 81]; [208, 228, 259, 269, 279]; [10, 30, 60, 80, 90]; [10, 30, 60, 80, 90]; [20, 62, 88, 128, 148]; [30, 72, 98, 138, 158]; [30, 72, 98, 138, 158]; [30, 72, 98, 138, 158]; [30, 72, 98, 138, 158]; [30, 72, 98, 138, 158]; [30, 72, 98, 138, 158]; [11, 46, 96, 148, 171]; [60, 95, 145, 197, 220]; [63, 98, 148, 200, 223]; [72, 107, 157, 209, 232]; [72, 107, 157, 209, 232]; [72, 107, 157, 209, 232]; [72, 107, 157, 209, 232]; [72, 123, 173, 193, 208]; [72, 123, 173, 193, 208]; [95, 146, 196, 216, 231]; [98, 149, 199, 219, 234]; [107, 158, 208, 228, 243]; [107, 158, 208, 231, 246]; [107, 158, 209, 229, 244]; [107, 157, 209, 249, 259]; [123, 173, 209, 249, 259]; [123, 173, 209, 249, 259]; [147, 197, 242, 282, 292]; [149, 199, 217, 258, 268]; [208, 260, 272, 312, 322]; [158, 208, 222, 262, 272]; [158, 208, 232, 242, 292]; [158, 209, 230, 240, 290]; [173, 209, 240, 250, 300]; [46, 58, 70, 80, 130]; [189, 209, 228, 238, 288]; [201, 222, 251, 262, 312]; [0, 12, 22, 32, 82]; ]; 
%matrix containing the type of the plant: plants from 1 to 7 are of type 0, in this case the strawberries.
 Plantsnames=[0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6];
 Plantsnames=Plantsnames+1;
 maxplantschange=max(Plantschange);
 %detection of the cycle time 
 time=maxplantschange(5);
 size_vector=size(Plantschange);
 %detection of the number of plants 
 number_of_plants=size_vector(1);
%% definition of the shelves 
% 8 spots per shelf 
trails=zeros(4,8);


%% Definition of the types of plants
% name_type = [ name, calories, time_shelf_1, time_shelf_2,
% time_shelf_3, time_shelf_4, calories_per_plant ] time is mesured in hours
Data_plants(1,:)={"fraise",120,10,20,30,20,};%strawberry
Data_plants(2,:)={"radis",230,20,21,10,10,};%radish 
Data_plants(3,:)={"roquette",150,42,26,40,20,};%arugula 
Data_plants(4,:)={"laitue",400,35,50,52,23,}; %letuce 
Data_plants(5,:)={"piment",100,51,50,20,15,}; %pepper
Data_plants(6,:)={"épinard",170,21,12,40,10,}; %spinach
Data_plants(7,:)={"basilic",80,12,10,10,50,}; %basil 

%% Definition of system physics
hour_check=0; % Boolean variableused to verify if the prescripted time between two loops.  
base_de_temps = 0; % 0 : instanteanous calculus, 1 : 1 second = 1 hour , 2 : 2 seconds = 1 hour etc..
show_etat_sys_auto = 1; % number of hours at the end of which the file gives a summary of the systems state. 
%% number of plants of each type employed in the system. 
etat_plante = zeros(number_of_plants,4); %state table of all the plants 
%column 1 : trails
%column 2 : location
%column 3 : completion of the current grow stage
%column 4 : completion of the global growing

%% Data initialisation 

for i = 1 : 50
   
   finaldoc{i,1}=Plantschange(i,1);
   finaldoc{i,3}=Plantschange(i,2);
   finaldoc{i,5}=Plantschange(i,3);
   finaldoc{i,7}=Plantschange(i,4);
   finaldoc{i,9}=Plantschange(i,5);
   finaldoc{i,10}=Data_plants{Plantsnames(i),1};
   
end

calories_recolte=0;
temps_ecoule=0;
compteur=1;
%% loops of the program 
while (temps_ecoule<time+1)
t1=fix(clock);
%harvest


%research of the plant ready to be harvested; free the spot if the harvest takes place.
    i=1;
    while i<number_of_plants+1
          if(temps_ecoule==Plantschange(i,5))
            calories_recolte=calories_recolte+Data_plants{Plantsnames(i),2};
            trails(4,etat_plante(i,2))=0; 
            etat_plante(i,1)=-1;
            etat_plante(i,2)=-1;
            etat_plante(i,3)=100;
            etat_plante(i,4)=100;
           
          end
        i=i+1;
    end

%Shelf 4
%research of the plant reasy to enter shelf 4
%checks if a spot in shelf 4 is avaible and if so frees a spot in shelf 3 
i=1;
while i<number_of_plants+1
        if(temps_ecoule==Plantschange(i,4))
            i_etagere=1;
            while i_etagere<9
                if trails(4,i_etagere)== 0
                   trails(3,etat_plante(i,2))=0;
                   trails(4,i_etagere)= 1;
                   etat_plante(i,1)=4;
                   etat_plante(i,2)=i_etagere;
                   finaldoc{i,8}=i_etagere;
                   i_etagere=9;
                end
                i_etagere=i_etagere+1;
            end
        end
        i=i+1;
end

%Shelf 3
%research of the plant reasy to enter shelf 3
%checks if a spot in shelf 3 is avaible and if so frees a spot in shelf 2 

i=1;
while i<number_of_plants+1
        if(temps_ecoule==Plantschange(i,3))
            i_etagere=1;
            while i_etagere<9
                if trails(3,i_etagere)== 0
                   trails(2,etat_plante(i,2))=0;
                   trails(3,i_etagere)= 1;
                   etat_plante(i,1)=3;
                   etat_plante(i,2)=i_etagere;
                   finaldoc{i,6}=i_etagere;
                   i_etagere=9;
                end
                i_etagere=i_etagere+1;
            end
        end
        i=i+1;
end

%Shelf 2
%research of the plant reasy to enter shelf 2
%checks if a spot in shelf 2 is avaible and if so frees a spot in shelf 1 
i=1;
while i<number_of_plants+1    
        if(temps_ecoule==Plantschange(i,2))
            i_etagere=1;
            while i_etagere<9
                if trails(2,i_etagere)== 0
                   trails(1,etat_plante(i,2))=0;
                   trails(2,i_etagere)= 1;
                   etat_plante(i,1)=2;
                   etat_plante(i,2)=i_etagere;
                   finaldoc{i,4}=i_etagere;
                   i_etagere=9;
                end
                i_etagere=i_etagere+1;
            end
        end
     i=i+1;
end

%Shelf 1
%research of the plant reasy to enter shelf 1
%checks if a spot in shelf 1 is avaible. 
i=1;                                        
while i<number_of_plants+1                    
     if (temps_ecoule==Plantschange(i,1))           
          i_etagere=1;
          while i_etagere<9
              if trails(1,i_etagere)== 0
                   trails(1,i_etagere)= 1;
                   etat_plante(i,1)=1;
                   etat_plante(i,2)=i_etagere;
                   finaldoc{i,2}=i_etagere;
                  i_etagere=9;
              end
              i_etagere=i_etagere+1;
          end
     end
      i=i+1;
end








    
%Upgrade of the growth value 
%Computes the growth percentage on the overall cycle and on also
%on the the one of the current stage. 
%Only works for plants allready on a shelf. 

i=1;
while i<number_of_plants+1
    if (Plantschange(i,1)<temps_ecoule) && (Plantschange(i,5)>temps_ecoule)
        etat_plante(i,4)=((temps_ecoule-Plantschange(i,1))/(Plantschange(i,5)-Plantschange(i,1))*100);
        etat_plante(i,3)=((temps_ecoule-Plantschange(i,etat_plante(i,1)))/(Plantschange(i,etat_plante(i,1)+1)-Plantschange(i,etat_plante(i,1)))*100);
    end

i=i+1;
end

if (mod(temps_ecoule,show_etat_sys_auto)==0) && (show_etat_sys_auto~=0)
 for i=1:50
     for i2=1:4
     summary{i,i2}=etat_plante(i,i2);
     end
     summary{i,5}=Data_plants{Plantsnames(i),1};
 end
 cal=sprintf("calories récoltés : %d",calories_recolte);
 summary{51,1}=cal;
 filename=sprintf("summar_hour_ %d .txt",temps_ecoule);
 writecell(summary,filename)
end

%loop allowing the the program to be used in real time or in the chosed time basis.

if (base_de_temps ~= 0)
while (hour_check==0)
    t2=fix(clock);
    time_elapsed=etime(t2,t1);
    if time_elapsed>base_de_temps
        hour_check=1;
    end
end
end
hour_check=0;    
temps_ecoule=temps_ecoule+1;
end

 writecell(finaldoc,"finaldoc.txt");