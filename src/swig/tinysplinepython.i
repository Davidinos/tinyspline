%module tinysplinepython

%ignore tinyspline::BSpline::operator=;
%ignore tinyspline::DeBoorNet::operator=;
%ignore tinyspline::Domain::operator=;
%ignore tinyspline::Frame::operator=;
%ignore tinyspline::FrameSeq::operator=;
%ignore tinyspline::Vec3::operator=;

%rename (__repr__) tinyspline::BSpline::toString;
%rename (__repr__) tinyspline::DeBoorNet::toString;
%rename (__repr__) tinyspline::Domain::toString;
%rename (__repr__) tinyspline::Frame::toString;
%rename (__repr__) tinyspline::FrameSeq::toString;
%rename (__repr__) tinyspline::Morphism::toString;
%rename (__repr__) tinyspline::Vec3::toString;

%rename("%(undercase)s", %$isfunction) "";
%rename("%(undercase)s", %$ismember, %$not %$isconstructor) "";

// Map std::vector<tinyspline::real> to Python list.
%typemap(out) std::vector<tinyspline::real> * (int size, PyObject *data) {
	size = $1->size();
	$result = PyList_New(size);
	for (int i = 0; i < size; i++) {
		data = PyFloat_FromDouble((*$1)[i]);
		PyList_SetItem($result, i, data);
	}
}
%typemap(newfree) std::vector<tinyspline::real> * {
	delete $1;
}

// Map Python list to std::vector<tinyspline::real>.
%typemap(in) std::vector<tinyspline::real> * (int size, PyObject *data) %{
	size = PyList_Size($input);
	$1 = new std::vector<tinyspline::real>();
	$1->reserve(size);
	for (int i = 0; i < size; i++) {
		data = PyList_GetItem($input, i);
		$1->push_back(PyFloat_AsDouble(data));
	}
%}
%typemap(freearg) std::vector<tinyspline::real> * {
	delete $1;
}

%include "tinyspline.i"
