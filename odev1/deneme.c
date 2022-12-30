#include<stdio.h>
#include<stdlib.h>

int deneme(int i,int *hafiza);
 
int main(){
    int i = 0;
    static int hafiza[540];
    printf("Sonuc Hesaplaniyor\n");
    printf("sonuc: %d\n",deneme(510,hafiza));    
    for(i=0;i<520;i++){
          printf("hafiza[%d]: %d\n",i,hafiza[i]);    
    }
}

int deneme(int i,int *hafiza){
    int sonuc1 = 0; 
    int sonuc2 = 0;

    if(i == 0){
        return 0;
    }

    if( i == 1 || i == 2){
        return 1;
    }

    if(hafiza[i-1] == 0 ){
        sonuc1 = deneme(i-1,hafiza);
        hafiza[i-1] = sonuc1;
    }else{
        sonuc1 = hafiza[i-1];
    }

    if(hafiza[sonuc1] == 0 ){
        sonuc1 = deneme(sonuc1,hafiza);
        hafiza[sonuc1] = sonuc1;
    }else{
        sonuc1 = hafiza[sonuc1];
    }

    if(hafiza[i-2] == 0){
        sonuc2 = deneme(i-2,hafiza);
        hafiza[i-2] = sonuc2;
    }else{
        sonuc2 = hafiza[i-2];
    } 

    if(hafiza[i-1-sonuc2] == 0){
        sonuc2 = deneme(i-1-sonuc2,hafiza);
        hafiza[i-1-sonuc2] = sonuc2;
    }else{
        sonuc2 = hafiza[i-1-sonuc2];
    }
    hafiza[i] = sonuc1+sonuc2;
    
    return sonuc1+sonuc2;

}