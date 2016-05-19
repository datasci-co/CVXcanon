//    This file is part of CVXcanon.
//
//    CVXcanon is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    CVXcanon is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with CVXcanon.  If not, see <http://www.gnu.org/licenses/>.

%module cvxcanon_swig

%{
	#define SWIG_FILE_WITH_INIT
	#include "cvxcanon/CVXcanon.hpp"
        #include "cvxcanon/solver/Solver.hpp"
%}

%include "numpy.i"
%include "std_vector.i"
%include "std_map.i"

/* Must call this before using NUMPY-C API */
%init %{
	import_array();
%}

/* Typemap for the addDenseData C++ routine in LinOp.hpp */
%apply (double* IN_FARRAY2, int DIM1, int DIM2) {(double* matrix, int rows, int cols)};

/* Typemap for the addSparseData C++ routine in LinOp.hpp */
%apply (double* INPLACE_ARRAY1, int DIM1) {(double *data, int data_len),
	(double *row_idxs, int rows_len),
	(double *col_idxs, int cols_len)};

/* Typemap for the getV, getI, getJ, and getConstVec C++ routines in
	 problemData.hpp */
%apply (double* ARGOUT_ARRAY1, int DIM1) {(double* values, int num_values)}

/* Typemap for Solver::get_value */
%apply (int variable_id, int DIM1, int DIM2, double* ARGOUT_ARRAY1) {
  (int variable_id, int rows, int cols, double* value)};

/* Useful wrappers for the LinOp class */
namespace std {
   %template(IntVector) vector<int>;
   %template(DoubleVector) vector<double>;
   %template(IntVector2D) vector< vector<int> >;
   %template(DoubleVector2D) vector< vector<double> >;
   %template(IntIntMap) map<int, int>;
   %template(LinOpVector) vector< LinOp * >;
   %template(ExpressionVector) vector<Expression>;
}

/* Modify typemaps for for expression attributes so they aren't gc'd */
%typemap(out) ExpressionAttributes* {
  $result = SWIG_NewPointerObj(SWIG_as_voidptr(result), $1_descriptor, 0 );
}
%apply ExpressionAttributes* {
  ConstAttributes*,
  ReshapeAttributes*,
  PNormAttributes*,
  VarAttributes* };

%include "cvxcanon/CVXcanon.hpp"
%include "cvxcanon/expression/Expression.hpp"
%include "cvxcanon/linop/LinOp.hpp"
%include "cvxcanon/linop/ProblemData.hpp"
%include "cvxcanon/solver/Solver.hpp"