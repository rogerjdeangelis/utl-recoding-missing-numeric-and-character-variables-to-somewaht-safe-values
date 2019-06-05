Recoding missing numeric and character variables to somewaht safe values                                              
                                                                                                                      
I was recently given about 100 tables with up to 200 variables per table.                                             
The most frequent values were missing numerics and characters.                                                        
                                                                                                                      
Joins were required for almost all analysis.                                                                          
Joins could generate missing values and I need to differentiate the                                                   
generated missing values from the real missing values.                                                                
                                                                                                                      
   Steps                                                                                                              
                                                                                                                      
      1. Use FCMP to map character missing," ", to ?                                                                  
      2. Use FCMP to map numeric missing to constant('small'). (least destrutive - sums may be ok)                    
      3. Use FCMP to map constant('small') back to '.'                                                                
      4. Use FCMP to map "?" back to ' '                                                                              
                                                                                                                      
https://github.com/rogerjdeangelis/utl-recoding-missing-numeric-and-character-variables-to-somewhat-safe-values       
                                                                                                                      
*_                   _                                                                                                
(_)_ __  _ __  _   _| |_                                                                                              
| | '_ \| '_ \| | | | __|                                                                                             
| | | | | |_) | |_| | |_                                                                                              
|_|_| |_| .__/ \__,_|\__|                                                                                             
        |_|                                                                                                           
;                                                                                                                     
                                                                                                                      
data have;                                                                                                            
                                                                                                                      
  format death_dt date9.;                                                                                             
  informat death_dt date9.;                                                                                           
  input death_dt gender$;                                                                                             
                                                                                                                      
cards4;                                                                                                               
. .                                                                                                                   
01JAN1999 F                                                                                                           
;;;;                                                                                                                  
run;quit;                                                                                                             
                                                                                                                      
HAVE total obs=2                                                                                                      
                                                                                                                      
Obs     DEATH_DT    GENDER                                                                                            
                                                                                                                      
 1             .                                                                                                      
 2     01JAN1999      F                                                                                               
                                                                                                                      
*            _               _                                                                                        
  ___  _   _| |_ _ __  _   _| |_                                                                                      
 / _ \| | | | __| '_ \| | | | __|                                                                                     
| (_) | |_| | |_| |_) | |_| | |_                                                                                      
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                     
                |_|                                                                                                   
;                                                                                                                     
                                                                                                                      
WANT total obs=2                                                                                                      
                                Feel free to change                                                                   
         Original Values         Recoded values                                                                       
       --------------------    ----------------------                                                                 
        DEATH_                                                                                                        
Obs     DTBAC    GENDERBAC         DEATH_DT    GENDER                                                                 
                                                                                                                      
 1          .                  2.22507E-308      ?                                                                    
                                                                                                                      
 2      14245        F                14245      F                                                                    
                                                                                                                      
*                                                                                                                     
 _ __  _ __ ___   ___ ___  ___ ___                                                                                    
| '_ \| '__/ _ \ / __/ _ \/ __/ __|                                                                                   
| |_) | | | (_) | (_|  __/\__ \__ \                                                                                   
| .__/|_|  \___/ \___\___||___/___/                                                                                   
|_|                                                                                                                   
;                                                                                                                     
                                                                                                                      
proc fcmp outlib=work.functions.smd;                                                                                  
                                                                                                                      
   function nulfix(num) ;                                                                                             
      if num=. then return(constant('small'));                                                                        
      else return(num);                                                                                               
   endfunc;                                                                                                           
                                                                                                                      
   function nulbac(num) ;                                                                                             
      if num=constant('small') then return(.);                                                                        
      else return(num);                                                                                               
   endfunc;                                                                                                           
                                                                                                                      
   function chrfix(chr) $;                                                                                            
      if missing(chr) then return("?");                                                                               
      else return(chr);                                                                                               
   endfunc;                                                                                                           
                                                                                                                      
   function chrbac(chr $) $;                                                                                          
      if  chr="?" then return("");                                                                                    
      else return(chr);                                                                                               
   endfunc;                                                                                                           
                                                                                                                      
options cmplib=(work.functions);                                                                                      
                                                                                                                      
data want;                                                                                                            
                                                                                                                      
  set have;                                                                                                           
  format death_dt best12.;                                                                                            
                                                                                                                      
  death_dt     = nulfix(death_dt);                                                                                    
  gender       = chrfix(gender);                                                                                      
                                                                                                                      
  death_dtbac  = nulbac(death_dt);                                                                                    
  genderbac    = chrbac(gender);                                                                                      
                                                                                                                      
run;quit;                                                                                                             
                                                                                                                      
                                                                                                                      
