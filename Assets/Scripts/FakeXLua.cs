namespace XLua
{
    //在编辑场景的项目里不需要导入xlua了,但原项目里的某些类有引用到xlua,所以这里加下空的实现
    [AttributeUsage(AttributeTargets.Class,Inherited=false)]
    class HotfixAttribute : Attribute
    {
    }

    [AttributeUsage(AttributeTargets.Class,Inherited=false)]
    class LuaCallCSharpAttribute : Attribute
    {
    }
}