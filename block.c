#include <stdio.h>
int main(){
void(^testBlock)(void) = ^{
	printf("testBlock执行了");
};

testBlock();
}
