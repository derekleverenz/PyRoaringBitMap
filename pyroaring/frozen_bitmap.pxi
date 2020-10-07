cimport croaring

cdef const croaring.roaring_bitmap_t *deserialize_frozen_ptr(char *buff, size_t length):
    cdef const croaring.roaring_bitmap_t *ptr
    ptr = croaring.roaring_bitmap_frozen_view(buff, length)
    return ptr


cdef class FrozenBitMap(AbstractBitMap):
    def __ior__(self, other):
        '''Unsupported method.'''
        raise TypeError('Cannot modify a %s.' % self.__class__.__name__)

    def __iand__(self, other):
        '''Unsupported method.'''
        raise TypeError('Cannot modify a %s.' % self.__class__.__name__)

    def __ixor__(self, other):
        '''Unsupported method.'''
        raise TypeError('Cannot modify a %s.' % self.__class__.__name__)

    def __isub__(self, other):
        '''Unsupported method.'''
        raise TypeError('Cannot modify a %s.' % self.__class__.__name__)

    @classmethod
    def frozen_view(cls, char *buff, Py_ssize_t length):
        """
        Load a view of a bitmap from a frozen representation.
        This can be a pointer to a memory-mapped file.
        See AbstractBitMap.serialize_frozen for the reverse operation.

        >>> bitmap = BitMap([3, 12])
        >>> length = bitmap.frozen_size()
        >>> FrozenBitMap.frozen_view(bitmap).serialize_frozen(), length)
        FrozenBitMap([3, 12])
        """

        return (<FrozenBitMap>cls()).from_ptr(deserialize_frozen_ptr(buff, length)) # FIXME to change when from_ptr is a classmethod