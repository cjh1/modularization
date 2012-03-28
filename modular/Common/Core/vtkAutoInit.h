#ifndef __vtkAutoInit_h
#define __vtkAutoInit_h

#include "vtkDebugLeaksManager.h" // DebugLeaks exists longer.

#define VTK_AUTOINIT(M)				\
  VTK_AUTOINIT0(M##_AUTOINIT)
#define VTK_AUTOINIT0(L)			\
  VTK_AUTOINIT1(VTK_AI_LIST_SELECT_1(L))	\
  VTK_AUTOINIT1(VTK_AI_LIST_SELECT_2(L))	\
  VTK_AUTOINIT1(VTK_AI_LIST_SELECT_3(L))	\
  VTK_AUTOINIT1(VTK_AI_LIST_SELECT_4(L))	\
  VTK_AUTOINIT1(VTK_AI_LIST_SELECT_5(L))	\
  VTK_AUTOINIT1(VTK_AI_LIST_SELECT_6(L))	\
  VTK_AUTOINIT1(VTK_AI_LIST_SELECT_7(L))	\
  VTK_AUTOINIT1(VTK_AI_LIST_SELECT_8(L))	\
  VTK_AUTOINIT1(VTK_AI_LIST_SELECT_9(L))

#define VTK_AUTOINIT1(L) VTK_AUTOINIT2(L,VTK_AI_LIST_EMPTY(L))
#define VTK_AUTOINIT2(L,EMPTY) VTK_AUTOINIT3(L,EMPTY)
#define VTK_AUTOINIT3(L,EMPTY) VTK_AUTOINIT3_##EMPTY(L)
#define VTK_AUTOINIT3_0(L) VTK_AUTOINIT4(VTK_AI_LIST_CAR(L))
#define VTK_AUTOINIT3_1(L)
#define VTK_AUTOINIT4(M) VTK_AUTOINIT5(M)
#define VTK_AUTOINIT5(M) VTK_AUTOINIT6(M##_AutoInit)
#define VTK_AUTOINIT6(MI)                                               \
  struct MI { MI(); ~MI(); }; static MI MI##_Instance;

#define VTK_AI_LIST_SELECT_1(L) L
#define VTK_AI_LIST_SELECT_2(L) VTK_AI_LIST_SELECT_1(VTK_AI_LIST_CDR(L))
#define VTK_AI_LIST_SELECT_3(L) VTK_AI_LIST_SELECT_2(VTK_AI_LIST_CDR(L))
#define VTK_AI_LIST_SELECT_4(L) VTK_AI_LIST_SELECT_3(VTK_AI_LIST_CDR(L))
#define VTK_AI_LIST_SELECT_5(L) VTK_AI_LIST_SELECT_4(VTK_AI_LIST_CDR(L))
#define VTK_AI_LIST_SELECT_6(L) VTK_AI_LIST_SELECT_5(VTK_AI_LIST_CDR(L))
#define VTK_AI_LIST_SELECT_7(L) VTK_AI_LIST_SELECT_6(VTK_AI_LIST_CDR(L))
#define VTK_AI_LIST_SELECT_8(L) VTK_AI_LIST_SELECT_7(VTK_AI_LIST_CDR(L))
#define VTK_AI_LIST_SELECT_9(L) VTK_AI_LIST_SELECT_8(VTK_AI_LIST_CDR(L))

#define VTK_AI_LIST_EMPTY(L) VTK_AI_LIST_EMPTY0(VTK_AI_LIST_EMPTY_TEST(L))
#define VTK_AI_LIST_EMPTY0(T) VTK_AI_LIST_EMPTY1(T)
#define VTK_AI_LIST_EMPTY1(T) VTK_AI_LIST_EMPTY_##T
#define VTK_AI_LIST_EMPTY_TEST(L) VTK_AI_LIST_EMPTY_TEST_1 L
#define VTK_AI_LIST_EMPTY_TEST_1(car,cdr) VTK_AI_LIST_EMPTY_TEST_0
#define VTK_AI_LIST_EMPTY_VTK_AI_LIST_EMPTY_TEST_0 0
#define VTK_AI_LIST_EMPTY_VTK_AI_LIST_EMPTY_TEST_1 1

#define VTK_AI_LIST_APPLY(m,L) VTK_AI_LIST_APPLY0(m,L)
#define VTK_AI_LIST_APPLY0(m,L) VTK_AI_LIST_APPLY1(m,L,VTK_AI_LIST_EMPTY(L))
#define VTK_AI_LIST_APPLY1(m,L,EMPTY) VTK_AI_LIST_APPLY2(m,L,EMPTY)
#define VTK_AI_LIST_APPLY2(m,L,EMPTY) VTK_AI_LIST_APPLY2_##EMPTY(m,L)
#define VTK_AI_LIST_APPLY2_0(m,L) m L
#define VTK_AI_LIST_APPLY2_1(m,L)

#define VTK_AI_LIST_CAR(L) VTK_AI_LIST_APPLY(VTK_AI_LIST_CAR_,L)
#define VTK_AI_LIST_CAR_(car,cdr) car

#define VTK_AI_LIST_CDR(L) VTK_AI_LIST_APPLY(VTK_AI_LIST_CDR_,L)
#define VTK_AI_LIST_CDR_(car,cdr) cdr

#endif
