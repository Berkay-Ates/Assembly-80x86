#include <windows.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <iostream>
#include "image_processing.cpp"

using namespace std;

void Dilation(int n, int filter_size, short* resimadres_org);
void Erosion(int n, int filter_size, short* resimadres_org);

int main(void) {
	int M, N, Q, i, j, filter_size;
	bool type;
	int efile;
	char org_resim[100], dil_resim[] = "dilated.pgm", ero_resim[] = "eroded.pgm";
	do {
		printf("Orijinal resmin yolunu (path) giriniz:\n-> ");
		scanf("%s", &org_resim);
		system("CLS");
		efile = readImageHeader(org_resim, N, M, Q, type);
	} while (efile > 1);
	int** resim_org = resimOku(org_resim);

	printf("Orjinal Resim Yolu: \t\t\t%s\n", org_resim);

	short *resimdizi_org = (short*) malloc(N*M * sizeof(short));

	for (i = 0; i < N; i++)
		for (j = 0; j < M; j++)
			resimdizi_org[i*N + j] = (short)resim_org[i][j];

	int menu;
	printf("Yapmak istediginiz islemi giriniz...\n");
	printf("1-) Dilation\n");
	printf("2-) Erosion\n");
	printf("3-) Cikis\n> ");
	scanf("%d", &menu);
	printf("Filtre boyutunu giriniz: ");
	scanf("%d", &filter_size);

	switch (menu){
		case 1:
			Dilation(N*M, filter_size, resimdizi_org);
			resimYaz(dil_resim, resimdizi_org, N, M, Q);
			break;
		case 2:
			Erosion(N*M, filter_size, resimdizi_org);
			resimYaz(ero_resim, resimdizi_org, N, M, Q);
			break;
		case 3:
			system("EXIT");
			break;
		default:
			system("EXIT");
			break;
	}

	system("PAUSE");
	return 0;
}

void Dilation(int n, int filter_size, short* resim_org) {
	__asm {
		
		// resmi asagıdan yukarı dogru stacke atalım 
		mov eax,n 
		shl eax,1
		add eax,resim_org
		mov edi,eax 			// edi resmin en sonunda 
		sub edi,4
		mov ecx,n 
		shr ecx,1 
cpstc:	mov eax, dword ptr [edi]
		push eax 
		sub edi,4 
		loop cpstc
		// resmin tamamı stack icrisine gitmis vaziyette biz de stack uzerinde dolanıyor olacagız 

		xor ecx, ecx
sqr:	inc ecx
		mov eax, ecx
		mul ecx
		cmp eax, n
		jne sqr

		mov ebx,ecx			// resmin boyutu suanda ebx icerisinde 


		
		mov ecx,ebx
		dec ecx 
imgI:	push ecx 

		mov ecx,ebx				// j ayarland˝ 
		
imgJ:	push ecx			

		mov ecx,filter_size		// k ayarland˝ 
kerK:	push ecx

		mov ecx,filter_size		// L ayarlandı
kerL:	mov eax,filter_size 
		shr eax, 1
		add eax, [esp + 8]
		sub eax, [esp]//eax icerisinde suanda i+filter_size/2-k degeri var 
		cmp eax, 0
		jl ext
		cmp eax, ebx
		jnb ext
		mov edx, filter_size			// yatayd kontrol 
		shr edx, 1
		add edx, [esp + 4]
		sub edx, ecx
		cmp edx, 0
		jl ext
		cmp edx, ebx
		jnb ext
		push edx 
		mul ebx 
		pop edx 
		add eax,edx		// resmin kacıncı pixeli kontrol edilecekse oradayız suanda (kernel bakacak) 
		// pixel sayısı CIFT ise dx ile kıysalama yapıyorumdur 
		// pixel sayısı TEK ise edx'in yüksek anlamlı kısmı ile kıyaslama yapıyorum 
		// stacke erisirken eax bana hep cift olarak lazım tek olmasını istemiyoruz 
		// kontrol edelim tek ise bir azaltalım 
		shl eax,1 
		add eax,resim_org
		mov edi,eax			// edi icerisinde kernelin kontrol etmek istedigi noktanın addresi var suanda 

		jmp l1 
l44:	jmp imgI

		jmp l1 
l33:	jmp imgJ

		jmp l1
l22:	jmp kerK 

		jmp l1
l11:	jmp kerl

l1:		mov eax,[esp+8]
		mul ebx 
		add eax,[esp+4]		// eax de resmin kernel merkezine gelen pixel numarası var 
		// bu numaradaki degeri stackten okuyalım ve kıyaslama yapıp gerekiyorsa stacke geri yazalım 
		test eax,eax
		jc tek
		shl eax,1
		mov edx,[esp+eax+8] // dx'i kontrol edecegiz 
		mov ax,word ptr[edi]
		cmp dx,ax 
		ja ext 
		mov dx,ax 
		jmp toStk 
tek:	inc eax 
		shl eax,1
		mov edx,[esp+eax+8]
		mov ax,word ptr[edi]	// edx'in yuksek anlamlı kısmını dusuk anlamlı kısma getirmemiz lazım 
		// saga dogru 16 defa kaysırmamız lazım 
		push ecx 
		mov cl,16 
		rol edx,cl 
		pop ecx 
		cmp dx,ax 
		ja ext
		// above degilse is var 
		mov dx,ax 
		push ecx
		mov cl,16
		rol edx,cl 
		pop ecx 
toStk:  mov eax, [esp + 8]
		push edx 
	    mul ebx
		pop edx 
	    add eax, [esp + 4]		// eax de resmin kernel merkezine gelen pixel numarası var 
		shl eax,1 
		mov [esp + eax + 8],edx

ext:	loop l11 
		pop ecx 
		loop l22 
		pop ecx 
		loop l33 
		pop ecx 
		loop l44 



		// simdi stacki resme geri yazma zamanı 
		// stack zaten yukarıdan assagı duz bir sekilde resmi barındırıyor 
		mov ecx,n
		shr ecx,1 
		mov edi,resim_org
stimg:  pop eax
		mov dword ptr[edi],eax		
		add edi,4
		loop stimg

	}
	printf("\nDilation islemi sonucunda resim \"dilated.pgm\" ismiyle olusturuldu...\n");
}

void Erosion(int n, int filter_size, short* resim_org) {
	__asm {
	
				// resmi asagıdan yukarı dogru stacke atalım 
		mov eax,n 
		shl eax,1
		add eax,resim_org
		mov edi,eax 			// edi resmin en sonunda 
		sub edi,4
		mov ecx,n 
		shr ecx,1 
cpstc:	mov eax, dword ptr [edi]
		push eax 
		sub edi,4 
		loop cpstc
		// resmin tamamı stack icrisine gitmis vaziyette biz de stack uzerinde dolanıyor olacagız 

		xor ecx, ecx
sqr:	inc ecx
		mov eax, ecx
		mul ecx
		cmp eax, n
		jne sqr

		mov ebx,ecx			// resmin boyutu suanda ebx icerisinde 


		
		mov ecx,ebx	
		dec ecx
imgI:	push ecx 

		mov ecx,ebx				// j ayarland˝ 
imgJ:	push ecx			

		mov ecx,filter_size		// k ayarland˝ 
kerK:	push ecx

		mov ecx,filter_size		// L ayarlandı
kerL:	mov eax,filter_size 
		shr eax, 1
		add eax, [esp + 8]
		sub eax, [esp]//eax icerisinde suanda i+filter_size/2-k degeri var 
		cmp eax, 0
		jl ext
		cmp eax, ebx
		jnb ext
		mov edx, filter_size			// yatayd kontrol 
		shr edx, 1
		add edx, [esp + 4]
		sub edx, ecx
		cmp edx, 0
		jl ext
		cmp edx, ebx
		jnb ext
		push edx 
		mul ebx 
		pop edx 
		add eax,edx		// resmin kacıncı pixeli kontrol edilecekse oradayız suanda (kernel bakacak) 
		// pixel sayısı CIFT ise dx ile kıysalama yapıyorumdur 
		// pixel sayısı TEK ise edx'in yüksek anlamlı kısmı ile kıyaslama yapıyorum 
		// stacke erisirken eax bana hep cift olarak lazım tek olmasını istemiyoruz 
		// kontrol edelim tek ise bir azaltalım 
		shl eax,1 
		add eax,resim_org
		mov edi,eax			// edi icerisinde kernelin kontrol etmek istedigi noktanın addresi var suanda 

		jmp l1 
l44:	jmp imgI

		jmp l1 
l33:	jmp imgJ

		jmp l1
l22:	jmp kerK 

		jmp l1
l11:	jmp kerl

l1:		mov eax,[esp+8]
		mul ebx 
		add eax,[esp+4]		// eax de resmin kernel merkezine gelen pixel numarası var 
		// bu numaradaki degeri stackten okuyalım ve kıyaslama yapıp gerekiyorsa stacke geri yazalım 
		test eax,eax
		jc tek
		shl eax,1
		mov edx,[esp+eax+8] // dx'i kontrol edecegiz 
		mov ax,word ptr[edi]
		cmp dx,ax 
		jb ext 
		mov dx,ax 
		jmp toStk 
tek:	inc eax 
		shl eax,1
		mov edx,[esp+eax+8]
		mov ax,word ptr[edi]	// edx'in yuksek anlamlı kısmını dusuk anlamlı kısma getirmemiz lazım 
		// saga dogru 16 defa kaysırmamız lazım 
		push ecx 
		mov cl,16 
		rol edx,cl 
		pop ecx 
		cmp dx,ax 
		jb ext
		// above degilse is var 
		mov dx,ax 
		push ecx
		mov cl,16
		rol edx,cl 
		pop ecx 
toStk:  mov eax, [esp + 8]
		push edx 
	    mul ebx
		pop edx 
	    add eax, [esp + 4]		// eax de resmin kernel merkezine gelen pixel numarası var 
		shl eax,1 
		mov [esp + eax + 8],edx

ext:	loop l11 
		pop ecx 
		loop l22 
		pop ecx 
		loop l33 
		pop ecx 
		loop l44 



		// simdi stacki resme geri yazma zamanı 
		// stack zaten yukarıdan assagı duz bir sekilde resmi barındırıyor 
		mov ecx,n
		shr ecx,1 
		mov edi,resim_org
stimg:  pop eax
		mov dword ptr[edi],eax		
		add edi,4
		loop stimg
	}
	printf("\nErosion islemi sonucunda resim \"eroded.pgm\" ismiyle olusturuldu...\n");
}
