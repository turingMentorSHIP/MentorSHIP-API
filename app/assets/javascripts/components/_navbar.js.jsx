var Navbar = React.createClass({
  render() {
    return (
      <nav>
       <div className="nav-wrapper">
         <a href="/" className="brand-logo">mentorSHIP</a>
         <ul id="nav-mobile" className="right hide-on-med-and-down">
           <li><a href="/">Home</a></li>
           <li><a href="/about">How It Works</a></li>
         </ul>
       </div>
      </nav>
    )
  }
});