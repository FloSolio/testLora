#include <stdio.h>
#include "sx1302_hal/libloragw/inc/loragw_hal.h"

int main(int argc, char *argv[])
{
    printf("Hello Solioti 2!\n");

    printf("%s",lgw_version_info() );
    
    return 0;
}
