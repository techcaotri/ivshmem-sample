#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h>
#include <fcntl.h>
#include "ivshmem_config.h"

#define SHM_MESSAGE "Other VM says Hello!"

int main()
{
    int fd, shm_msg_len = strlen(SHM_MESSAGE)+1;
    void *shm;
    char *error, *buffer;

    /* Open memory device */
    fd = open("/dev/mem", O_RDWR);
    if (fd < 0)
    {
        error = "unable to open /dev/mem";
        goto exit;
    }

    /* Create a new mapping in the process' virtual address space */
    shm = mmap(NULL, SHM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, SHM_BAR);
    if (shm == MAP_FAILED)
    {
        close(fd);
        error = "unable to mmap shared memory";
        goto exit;
    }
    printf("Checkpoint: mmap successful\n");

    /* Check if there is something to read from shared memory; otherwise, push something */
    if (((char *)shm)[0] != '\0')
    {
        buffer = malloc(shm_msg_len);
        for (int i = 0; i < shm_msg_len; i++)
        {
            char c = ((char *)shm)[i];
            buffer[i] = c;
            if (c == '\0') break;
        }
        if (buffer[shm_msg_len-1] != '\0') buffer[shm_msg_len-1] = '\0';

        printf("Case 1: Read from shmem - '%s'\n", buffer);

        memset(buffer, 0, shm_msg_len);
        memcpy(shm, buffer, shm_msg_len);
        free(buffer);
    }
    else
    {
        memcpy(shm, SHM_MESSAGE, shm_msg_len);
        printf("Case 2: Written to shmem - '%s'; run this program again on another VM\n", SHM_MESSAGE);
    }

    munmap(shm, SHM_SIZE);
    close(fd);

    return 0;

exit:
    perror(error);
    return 1;
}
