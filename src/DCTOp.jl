export DCTOp

"""
  DCTOp(T::Type, shape::Tuple, dcttype=2)

returns a `DCTOp <: AbstractLinearOperator` which performs a DCT on a given input array.

# Arguments:
* `T::Type`       - type of the array to transform
* `shape::Tuple`  - size of the array to transform
* `dcttype`       - type of DCT (currently `2` and `4` are supported)
"""
function DCTOp(T::Type, shape::Tuple, dcttype=2)
  if dcttype == 2
    plan = plan_dct(zeros(T,shape))
    iplan = plan_idct(zeros(T,shape))
    return LinearOperator(prod(shape), prod(shape), true, false
            , x->vec(plan*reshape(x,shape))
            , nothing
            , y->vec(iplan*reshape(y,shape)))
  elseif dcttype == 4
    factor = sqrt(1.0/(prod(shape)* 2^length(shape)) )
    plan = FFTW.plan_r2r(zeros(T,shape),FFTW.REDFT11)
    return LinearOperator(prod(shape), prod(shape), true, false
            , x->vec((plan*reshape(x,shape)).*factor)
            , x->vec((plan*reshape(x,shape)).*factor)
            , nothing )
  else
    error("DCT type $(dcttype) not supported")
  end
end
