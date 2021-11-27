#pragma once

#include <stdint.h>

#ifndef __UNCONST
#define __UNCONST(a)   ((void *)(uintptr_t)(const void *)(a))
#endif /* __UNCONST */

#ifndef USE_ARG
#define USE_ARG(x)       /*LINTED*/(void)&(x)
#endif /* USE_ARG */


typedef uint8_t u_char;

#define MIN(x,y) ({ \
    typeof(x) _x = (x);     \
    typeof(y) _y = (y);     \
    (void) (&_x == &_y);    \
    _x < _y ? _x : _y; })
