var Navbar = React.createClass({
  render() {
    return (
      <nav>
       <div className="nav">
        <a href="/" className="brand-logo">mentor<span className="ship-word-navbar">SHIP</span></a>
         <ul id="nav-mobile" className="right hide-on-med-and-down">
           <li><a href="/">Home</a></li>
           <li><a href="/about">How It Works</a></li>
           <li><a href='/auth/census'>Log In With Census</a></li>
         </ul>
       </div>
      </nav>
    )
  }
});
