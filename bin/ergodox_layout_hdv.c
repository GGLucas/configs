/* ----------------------------------------------------------------------------
 * Copyright (c) 2013 Ben Blazak <benblazak.dev@gmail.com>
 * Released under The MIT License (see "doc/licenses/MIT.md")
 * Project located at <https://github.com/benblazak/ergodox-firmware>
 * ------------------------------------------------------------------------- */

/**                                                                 description
 * A Dvorak layout adapted from the default Kinesis layout.  The position of
 * the symbol keys on the function layer was (roughly) taken from the Arensito
 * layout.
 *
 * Implements the "layout" section of '.../firmware/keyboard.h'
 */


#include "./common/definitions.h"


// ----------------------------------------------------------------------------
// matrix control
// ----------------------------------------------------------------------------

#include "./common/exec_key.c.h"


// ----------------------------------------------------------------------------
// LED control
// ----------------------------------------------------------------------------

void kb__led__logical_on(char led) {
    switch(led) {
        case 'N': kb__led__on(1); break;  // numlock
        case 'C': kb__led__on(2); break;  // capslock
        case 'S': kb__led__on(3); break;  // scroll lock
        case 'O':                 break;  // compose
        case 'K':                 break;  // kana
    };
}

void kb__led__logical_off(char led) {
    switch(led) {
        case 'N': kb__led__off(1); break;  // numlock
        case 'C': kb__led__off(2); break;  // capslock
        case 'S': kb__led__off(3); break;  // scroll lock
        case 'O':                  break;  // compose
        case 'K':                  break;  // kana
    };
}


// ----------------------------------------------------------------------------
// keys
// ----------------------------------------------------------------------------

#include "./common/keys.c.h"

KEYS__LAYER__NUM_PUSH(10, 3);
KEYS__LAYER__NUM_POP(10);

void P(togl2)(void) {
    layer_stack__push(0, 2, 2);
}

void R(togl2)(void) {
    layer_stack__pop_id(2);
}

#define  KEYS__CTRLED(name, value)                              \
    void P(name) (void) { KF(press)(KEYBOARD__LeftControl);     \
                          KF(press)(value); }                   \
    void R(name) (void) { KF(release)(value);                   \
                          KF(release)(KEYBOARD__LeftControl); }

KEYS__CTRLED(ctrl_S, KEYBOARD__Semicolon_Colon);
KEYS__CTRLED(ctrl_C, KEYBOARD__i_I);
KEYS__CTRLED(ctrl_G, KEYBOARD__u_U);
KEYS__CTRLED(ctrl_V, KEYBOARD__Period_GreaterThan);
KEYS__CTRLED(ctrl_X, KEYBOARD__b_B);
KEYS__CTRLED(ctrl_U, KEYBOARD__f_F);

// ----------------------------------------------------------------------------
// layout
// ----------------------------------------------------------------------------

#include "./common/matrix.h"

static _layout_t _layout = {

// ............................................................................

    MATRIX_LAYER(  // layer 0 : default
// macro, unused,
       K,    nop,
// left hand ...... ......... ......... ......... ......... ......... .........
    dash,        1,        2,        3,        4,        5,      nop,
   slash,        q,        w,        e,        r,        t,  bkslash,
     esc,        a,        s,        d,        f,        g,
  shiftL,        z,        x,        c,        v,        b,      tab,
   ctrlL,      nop,      nop,     altL,     guiL,
                                                                 nop,   lpu1l1,
                                                       nop,      nop,      nop,
                                                        bs,      nop,      nop,
// right hand ..... ......... ......... ......... ......... ......... .........
             grave,        6,        7,        8,        9,        0,    equal,
             brktL,        y,        u,        i,        o,        p,    brktR,
                           h,        j,        k,        l,  semicol,    enter,
               nop,        n,        m,    comma,   period,    quote,   shiftR,
                                 togl2,     altR,      nop,      nop,    ctrlR,
     nop,      nop,
     nop,      nop,      nop,
     nop,      nop,    space  ),


    MATRIX_LAYER(  // layer 1 : keyboard functions
// macro, unused,
       K,    nop,
// left hand ...... ......... ......... ......... ......... ......... .........
   btldr,      nop,      nop,      nop,      nop,      nop,      nop,
     nop,      nop,      nop,      nop,      nop,      nop,      nop,
     nop,      nop,      nop,      nop,      nop,      nop,
     nop,      nop,      nop,      nop,      nop,      nop,      nop,
     nop,      nop,      nop,      nop,      nop,
                                                                 nop,   lpo1l1,
                                                       nop,      nop,      nop,
                                                       nop,      nop,      nop,
// right hand ..... ......... ......... ......... ......... ......... .........
               nop,      nop,      nop,      nop,      nop,      nop,      nop,
               nop,      nop,      nop,      nop,      nop,      nop,      nop,
                         nop,      nop,      nop,      nop,      nop,      nop,
               nop,      nop,      nop,      nop,      nop,      nop,      nop,
                                   nop,      nop,      nop,      nop,      nop,
     nop,      nop,
     nop,      nop,      nop,
     nop,      nop,      nop  ),


    MATRIX_LAYER(  // layer 2 : right alted keys
// macro, unused,
       K,    nop,
// left hand ...... ......... ......... ......... ......... ......... .........
     nop,       F1,       F2,       F3,       F4,       F5,      F11,
     nop,      nop,      nop,      nop,      nop,      nop,      nop,
     nop,      nop,      nop,      nop,      nop,      ins,
  shiftL,      nop,      nop,   arrowD,   arrowU,      del,      nop,
   ctrlL,      nop,      nop,     altL,     guiL,
                                                                 nop,      nop,
                                                       nop,      nop,      nop,
                                                       nop,      nop,      nop,
// right hand ..... ......... ......... ......... ......... ......... .........
               F12,       F6,       F7,       F8,       F9,      F10,      nop,
               nop,      nop,   ctrl_G,   ctrl_C,   ctrl_V,   arrowR,      nop,
                         nop,   arrowL,    pageD,    pageU,   ctrl_S,      nop,
               nop,      nop,      nop,   ctrl_X,   ctrl_U,      nop,   shiftR,
                                   nop,      altR,      nop,      nop,    ctrlR,
     nop,      nop,
     nop,      nop,      nop,
     nop,      nop,      nop  ),

// ............................................................................
};

