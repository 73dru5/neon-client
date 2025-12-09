function User({user}) {
    return (
        <>
            <div>
                {user.name ? <div>Hello, {user.name}</div> : <div>{user.message}</div>}
            </div>
        </>
    )
}

export default User