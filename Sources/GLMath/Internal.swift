// Copyright (c) 2015-2016 David Turnbull
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and/or associated documentation files (the
// "Materials"), to deal in the Materials without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Materials, and to
// permit persons to whom the Materials are furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Materials.
//
// THE MATERIALS ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// MATERIALS OR THE USE OR OTHER DEALINGS IN THE MATERIALS.

#if canImport(Darwin)
    import Darwin
#elseif canImport(Glibc)
    import Glibc
#elseif canImport(WinSDK)
    import WinSDK
#endif

// Not everyone will use this library as a module so we put all the
// internals into this class to avoid polluting the namespace.
// The API in this file is unstable and always will be.

public final class GLMath {
    // This is MurmurHash3 by Austin Appleby
    // https://en.wikipedia.org/wiki/MurmurHash
    public static func hash(_ nums: Int...) -> Int {
        #if !arch(i386) && !arch(arm)
            // 64 bit
            func rotl(_ x: UInt, _ r: UInt) -> UInt {
                return (x << r) | (x >> (64 - r))
            }
            func fmix(_ kk: UInt) -> UInt {
                var k = kk
                k ^= k >> 33
                k = k &* 0xff51_afd7_ed55_8ccd
                k ^= k >> 33
                k = k &* 0xc4ce_b9fe_1a85_ec53
                k ^= k >> 33
                return k
            }
            let c1: UInt = 0x87c3_7b91_1142_53d5
            let c2: UInt = 0x4cf5_ad43_2745_937f
            var h1: UInt = c1 ^ UInt(nums.count)
            var h2: UInt = c2 ^ UInt(nums.count)
            var data = nums.makeIterator()
            while true {
                if let k = data.next() {
                    var k1 = UInt(bitPattern: k) &* c1
                    k1 = rotl(k1, 31)
                    k1 = k1 &* c2
                    h1 ^= k1
                    h1 = rotl(h1, 27)
                    h1 = h1 &+ h2
                    h1 = h1 &* 5 + 0x52dc_e729
                } else {
                    break
                }
                if let k = data.next() {
                    var k2 = UInt(bitPattern: k) &* c2
                    k2 = rotl(k2, 33)
                    k2 = k2 &* c1
                    h2 ^= k2
                    h2 = rotl(h2, 31)
                    h2 = h2 &+ h1
                    h2 = h2 &* 5 + 0x3849_5ab5
                } else {
                    break
                }
            }
            h1 ^= UInt(nums.count)
            h2 ^= UInt(nums.count)
            h1 = h1 &+ h2
            h2 = h2 &+ h1
            h1 = fmix(h1)
            h2 = fmix(h2)
            h1 = h1 &+ h2
            h2 = h2 &+ h1
            return Int(bitPattern: h1)
        #else
            // 32 bit
            let c1: UInt = 0xcc9e_2d51
            let c2: UInt = 0x1b87_3593
            var h1: UInt = c1 ^ UInt(nums.count)
            for n in nums {
                var k1 = UInt(bitPattern: n)
                k1 = k1 &* c1
                k1 = (k1 << 15) | (k1 >> 17)
                k1 = k1 &* c2
                h1 ^= k1
                h1 = (h1 << 13) | (h1 >> 19)
                h1 = h1 &* 5 + 0xe654_6b64
            }
            h1 ^= UInt(nums.count)
            h1 ^= h1 >> 16
            h1 = h1 &* 0x85eb_ca6b
            h1 ^= h1 >> 13
            h1 = h1 &* 0xc2b2_ae35
            h1 ^= h1 >> 16
            return Int(bitPattern: h1)
        #endif
    }

    public static func sin<T: FloatingPointArithmeticType>(_ angle: T) -> T {
        if let z = angle as? Double {
            return sin(z) as! T
        }
        if let z = angle as? Float {
            return sinf(z) as! T
        }
        preconditionFailure()
    }

    public static func cos<T: FloatingPointArithmeticType>(_ angle: T) -> T {
        if let z = angle as? Double {
            return cos(z) as! T
        }
        if let z = angle as? Float {
            return cosf(z) as! T
        }
        preconditionFailure()
    }

    public static func tan<T: FloatingPointArithmeticType>(_ angle: T) -> T {
        if let z = angle as? Double {
            return tan(z) as! T
        }
        if let z = angle as? Float {
            return tanf(z) as! T
        }
        preconditionFailure()
    }

    public static func asin<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return asin(z) as! T
        }
        if let z = x as? Float {
            return asinf(z) as! T
        }
        preconditionFailure()
    }

    public static func acos<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return acos(z) as! T
        }
        if let z = x as? Float {
            return acosf(z) as! T
        }
        preconditionFailure()
    }

    public static func atan<T: FloatingPointArithmeticType>(_ y: T, _ x: T) -> T {
        if let z = y as? Double {
            return atan2(z, x as! Double) as! T
        }
        if let z = y as? Float {
            return atan2f(z, x as! Float) as! T
        }
        preconditionFailure()
    }

    public static func atan<T: FloatingPointArithmeticType>(_ yoverx: T) -> T {
        if let z = yoverx as? Double {
            return atan(z) as! T
        }
        if let z = yoverx as? Float {
            return atanf(z) as! T
        }
        preconditionFailure()
    }

    public static func sinh<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return sinh(z) as! T
        }
        if let z = x as? Float {
            return sinhf(z) as! T
        }
        preconditionFailure()
    }

    public static func cosh<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return cosh(z) as! T
        }
        if let z = x as? Float {
            return coshf(z) as! T
        }
        preconditionFailure()
    }

    public static func tanh<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return tanh(z) as! T
        }
        if let z = x as? Float {
            return tanhf(z) as! T
        }
        preconditionFailure()
    }

    public static func asinh<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return asinh(z) as! T
        }
        if let z = x as? Float {
            return asinhf(z) as! T
        }
        preconditionFailure()
    }

    public static func acosh<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return acosh(z) as! T
        }
        if let z = x as? Float {
            return acoshf(z) as! T
        }
        preconditionFailure()
    }

    public static func atanh<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return atanh(z) as! T
        }
        if let z = x as? Float {
            return atanhf(z) as! T
        }
        preconditionFailure()
    }

    public static func pow<T: FloatingPointArithmeticType>(_ x: T, _ y: T) -> T {
        if let z = x as? Double {
            return pow(z, y as! Double) as! T
        }
        if let z = x as? Float {
            return powf(z, y as! Float) as! T
        }
        preconditionFailure()
    }
    public static func exp<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return exp(z) as! T
        }
        if let z = x as? Float {
            return expf(z) as! T
        }
        preconditionFailure()
    }
    public static func log<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return log(z) as! T
        }
        if let z = x as? Float {
            return logf(z) as! T
        }
        preconditionFailure()
    }

    public static func exp2<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return exp2(z) as! T
        }
        if let z = x as? Float {
            return exp2f(z) as! T
        }
        preconditionFailure()
    }
    public static func log2<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return log2(z) as! T
        }
        if let z = x as? Float {
            return log2f(z) as! T
        }
        preconditionFailure()
    }

    public static func sqrt<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return sqrt(z) as! T
        }
        if let z = x as? Float {
            return sqrtf(z) as! T
        }
        preconditionFailure()
    }

    public static func floor<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return floor(z) as! T
        }
        if let z = x as? Float {
            return floorf(z) as! T
        }
        preconditionFailure()
    }

    public static func trunc<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return trunc(z) as! T
        }
        if let z = x as? Float {
            return truncf(z) as! T
        }
        preconditionFailure()
    }

    public static func round<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return round(z) as! T
        }
        if let z = x as? Float {
            return roundf(z) as! T
        }
        preconditionFailure()
    }

    public static func ceil<T: FloatingPointArithmeticType>(_ x: T) -> T {
        if let z = x as? Double {
            return ceil(z) as! T
        }
        if let z = x as? Float {
            return ceilf(z) as! T
        }
        preconditionFailure()
    }

    public static func modf<T: FloatingPointArithmeticType>(_ x: T, _ i: inout T) -> T {
        if let z = x as? Double {
            return withUnsafeMutablePointer(to: &i) {
                $0.withMemoryRebound(to: Double.self, capacity: 1) {
                    #if canImport(Darwin)
                        Darwin.modf(z, $0) as! T
                    #elseif canImport(Glibc)
                        Glibc.modf(z, $0) as! T
                    #elseif canImport(WinSDK)
                        WinSDK.modf(z, $0) as! T
                    #endif
                }
            }
        }
        if let z = x as? Float {
            return withUnsafeMutablePointer(to: &i) {
                $0.withMemoryRebound(to: Float.self, capacity: 1) {
                    modff(z, $0) as! T
                }
            }
        }
        preconditionFailure()
    }

    public static func fma<T: FloatingPointArithmeticType>(_ a: T, _ b: T, _ c: T) -> T {
        if let z = a as? Double {
            return fma(z, b as! Double, c as! Double) as! T
        }
        if let z = a as? Float {
            return fmaf(z, b as! Float, c as! Float) as! T
        }
        preconditionFailure()
    }

    public static func frexp<T: FloatingPointArithmeticType>(_ x: T, _ exp: inout Int32) -> T {
        if let z = x as? Double {
            return frexp(z, &exp) as! T
        }
        if let z = x as? Float {
            return frexpf(z, &exp) as! T
        }
        preconditionFailure()
    }

    public static func ldexp<T: FloatingPointArithmeticType>(_ x: T, _ exp: Int32) -> T {
        if let z = x as? Double {
            return ldexp(z, exp) as! T
        }
        if let z = x as? Float {
            return ldexpf(z, exp) as! T
        }
        preconditionFailure()
    }

    public static func floatFromHalf(_ i: UInt16) -> Float {
        let ret: UInt32
        var exponent = UInt32(i) & 0x7c00
        let sign = UInt32(i & 0x8000) << 16
        if exponent == 0 {
            var significand = UInt32(i & 0x03ff)
            if significand == 0 {
                // Zero
                ret = sign
            } else {
                // Subnormal
                significand <<= 1
                while (significand & 0x0400) == 0 {
                    significand <<= 1
                    exponent += 1
                }
                exponent = (127 - 15 - exponent) << 23
                significand = (significand & 0x03ff) << 13
                ret = sign | exponent | significand
            }
        } else if exponent == 0x7c00 {
            // inf or NaN
            ret = sign | 0x7f80_0000 | (UInt32(i & 0x03ff) << 13)
        } else {
            // Normal
            ret = sign | ((UInt32(i & 0x7fff) + 0x1c000) << 13)
        }
        return Float(bitPattern: ret)
    }

    public static func halfFromFloat(_ f: Float) -> UInt16 {
        let fbits = f.bitPattern
        let sign = UInt16((fbits & 0x8000_0000) >> 16)
        var exponent = fbits & 0x7f80_0000
        var significand: UInt32 = fbits & 0x007f_ffff

        if exponent <= 0x3800_0000 {
            // Exponent underflow
            if exponent < 0x3300_0000 {
                // Zero
                return sign
            }
            // Subnormal
            exponent >>= 23
            significand |= 0x0080_0000
            significand >>= 113 - exponent
            significand += 0x0000_1000
            return sign | UInt16(significand >> 13)
        }

        if exponent >= 0x4780_0000 {
            // Exponent overflow
            if exponent == 0x7f80_0000 && significand != 0 {
                // NaN
                significand >>= 13
                if significand == 0 {
                    return 0x7c01
                }
                return sign | 0x7c00 | UInt16(significand)
            }
            // Inf
            return sign | 0x7c00
        }

        // Nominal (must sum for correct rounding)
        exponent -= 0x3800_0000
        significand += 0x0000_1000
        return sign + UInt16(exponent >> 13) + UInt16(significand >> 13)
    }
}
