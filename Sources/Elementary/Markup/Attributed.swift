/// Mutable attribute storage for markup elements and attribute-modified content.
///
/// This underscored protocol lets attribute calls update the existing value
/// without introducing another ``ModifiedContent`` wrapper.
public protocol _Attributed {
    /// The attributes associated with this value.
    var _attributes: _AttributeStorage { get set }
}
