(function() {
  Phacker.Game.Socle = (function() {
    function Socle(gm) {
      this.gm = gm;
      this._fle_ = 'Socle';
      this.pm = this.gm.parameters = {};
      this.pm.spt = {
        vx0: 110
      };
      this.pm.bg = {
        x0: 0,
        y0: 48,
        w: this.gm.gameOptions.fullscreen ? 375 : 768,
        h: this.gm.gameOptions.fullscreen ? 559 : 500
      };
      this.pm.cld = {
        x0: -220,
        y0: this.pm.bg.y0,
        vx: 30,
        w: 768
      };
      this.pm.deco = {
        x0: 0,
        h: 240
      };
      this.pm.deco.y1_0 = this.pm.bg.h - this.pm.deco.h - 50;
      this.pm.deco.y2_0 = this.pm.bg.h - this.pm.deco.h;
      this.pm.sea = {
        x0: 0,
        h1: 64,
        h2: 59,
        h3: 52
      };
      this.pm.sea.y3_0 = this.pm.bg.h - this.pm.sea.h1;
      this.pm.sea.y2_0 = this.pm.bg.h - this.pm.sea.h2;
      this.pm.sea.y1_0 = this.pm.bg.h - this.pm.sea.h3;
      this.pm.pfm = {
        x0: 0,
        w: 218,
        h: 220
      };
      this.pm.pfm.y0 = this.pm.bg.h - this.pm.pfm.h;
      this.draw_bg();
    }

    Socle.prototype.draw_bg = function() {
      this.bg = this.gm.add.sprite(this.pm.bg.x0, this.pm.bg.y0, 'bg_gameplay');
      this.bg.fixedToCamera = true;
      this.cld1 = this.gm.add.sprite(this.pm.cld.x0, this.pm.cld.y0, 'cloud');
      this.gm.physics.arcade.enable(this.cld1, Phaser.Physics.ARCADE);
      this.cld1.body.velocity.x = -this.pm.cld.vx;
      this.cld2 = this.gm.add.sprite(this.pm.cld.x0 + this.pm.cld.w, this.pm.cld.y0, 'cloud');
      this.gm.physics.arcade.enable(this.cld2, Phaser.Physics.ARCADE);
      this.cld2.body.velocity.x = -this.pm.cld.vx;
      this.deco2 = this.gm.add.sprite(this.pm.deco.x0, this.pm.deco.y1_0, 'deco_2');
      this.deco2.fixedToCamera = true;
      this.deco1 = this.gm.add.sprite(this.pm.deco.x0, this.pm.deco.y2_0, 'deco_1');
      this.deco1.fixedToCamera = true;
      this.sea3 = this.gm.add.sprite(this.pm.sea.x0, this.pm.sea.y3_0, 'sea3');
      this.sea3.fixedToCamera = true;
      this.sea2 = this.gm.add.sprite(this.pm.sea.x0, this.pm.sea.y2_0, 'sea2');
      this.sea2.fixedToCamera = true;
      this.sea1 = this.gm.add.sprite(this.pm.sea.x0, this.pm.sea.y1_0, 'sea1');
      this.sea1.fixedToCamera = true;
      this.pfm = this.gm.add.sprite(this.pm.pfm.x0, this.pm.pfm.y0, 'platform');
      this.gm.physics.arcade.enable(this.pfm, Phaser.Physics.ARCADE);
      return this.pfm.body.immovable = true;
    };

    Socle.prototype.move_clouds = function(spt) {
      if (spt.x > this.pm.pfm.w) {
        this.cld1.body.velocity.x = this.pm.spt.vx0 - this.pm.cld.vx;
        this.cld2.body.velocity.x = this.pm.spt.vx0 - this.pm.cld.vx;
      }
      if (this.cld1.x + this.pm.cld.w + 70 < spt.x) {
        return this.cld1.x = this.cld2.x + this.pm.cld.w;
      } else if (this.cld2.x + this.pm.cld.w + 70 < spt.x) {
        return this.cld2.x = this.cld1.x + this.pm.cld.w;
      }
    };

    return Socle;

  })();

}).call(this);

(function() {
  Phacker.Game.Enemies = (function() {
    function Enemies(gm) {
      this.gm = gm;
      this._fle_ = 'Enemies';
      this.pm = this.gm.parameters.emy = {
        x0: this.gm.parameters.pfm.w + 80,
        y0: this.gm.parameters.pfm.y0,
        w: 50,
        h: 24,
        names: ['enemy2', 'enemy1'],
        nb: this.gm.gameOptions.fullscreen ? 4 : 7,
        dx: 70,
        ddx: .20
      };
      this.pm.y = [this.pm.y0 + 40, this.pm.y0, this.pm.y0 - 40, this.pm.y0 - 80];
      this.emy = this.gm.add.physicsGroup();
      this.emy.enableBody = true;
      this.init();
    }

    Enemies.prototype.init = function() {
      var dx, i, j, ref, results, xx, yy;
      dx = this.fdx();
      this.make_1_emy(this.pm.x0, this.pm.y0);
      xx = this.pm.x0 + dx;
      results = [];
      for (i = j = 2, ref = this.pm.nb; 2 <= ref ? j <= ref : j >= ref; i = 2 <= ref ? ++j : --j) {
        yy = this.pm.y[this.gm.rnd.integerInRange(1, 2)];
        this.make_1_emy(xx, yy);
        results.push(xx = this.last().x + dx);
      }
      return results;
    };

    Enemies.prototype.make_1_emy = function(x, y) {
      var anim, e;
      e = this.emy.create(x, y, this.pm.names[this.gm.rnd.integerInRange(0, 1)]);
      e.body.immovable = true;
      anim = e.animations.add('anim', [0, 1, 2, 3], 5, true);
      e.animations.play('anim');
      return e.touched = false;
    };

    Enemies.prototype.create_destroy = function() {
      var em0, x3;
      em0 = this.emy.getAt(0);
      if (this.gm.camera.x > em0.x + this.pm.w) {
        em0.destroy();
        x3 = this.emy.getAt(this.emy.length - 1).x + this.fdx();
        return this.make_1_emy(x3, this.pm.y[this.gm.rnd.integerInRange(1, 2)]);
      }
    };

    Enemies.prototype.len = function() {
      return this.emy.children.length;
    };

    Enemies.prototype.last = function() {
      return this.emy.getAt(this.emy.children.length - 1);
    };

    Enemies.prototype.fdx = function() {
      return this.pm.w + this.pm.dx + Math.floor(this.gm.ge.score / 60) * this.pm.dx * this.pm.ddx;
    };

    Enemies.prototype.bind = function(spt) {
      return this.spt = spt;
    };

    return Enemies;

  })();

}).call(this);


/* fc written on 2017-04-27 */

(function() {
  Phacker.Game.Mouse = (function() {
    function Mouse(gm, spt) {
      this.gm = gm;
      this.spt = spt;
      this._fle_ = 'Mouse';
      this.pm = this.gm.parameters.btn = {
        dx: this.gm.parameters.bg.w / 6,
        y: 500,
        w: 55,
        h: 55
      };
      this.pm.y = this.gm.parameters.bg.h - this.pm.h - 20;
      this.pm.leftX = this.gm.parameters.bg.w / 2 - this.gm.parameters.bg.w / 10 - this.pm.w;
      this.pm.rightX = this.gm.parameters.bg.w / 2 + this.gm.parameters.bg.w / 10;
      this.draw_buttons();
    }

    Mouse.prototype.draw_buttons = function() {
      this.l_btn = this.gm.add.button(this.pm.leftX, this.pm.y, 'left_btn', this.on_tapUp, this, 1, 1, 0);
      this.l_btn.fixedToCamera = true;
      this.l_btn.onInputDown.add(this.on_tapDownLeft, this);
      this.r_btn = this.gm.add.button(this.pm.rightX, this.pm.y, 'right_btn', this.on_tapUp, this, 1, 1, 0);
      this.r_btn.fixedToCamera = true;
      return this.r_btn.onInputDown.add(this.on_tapDownRight, this);
    };

    Mouse.prototype.on_tapUp = function() {
      return this.spt.body.velocity.x = this.gm.parameters.spt.vx0;
    };

    Mouse.prototype.on_tapDownLeft = function() {
      return this.spt.body.velocity.x -= this.gm.parameters.spt.dvx0;
    };

    Mouse.prototype.on_tapDownRight = function() {
      return this.spt.body.velocity.x += this.gm.parameters.spt.dvx0;
    };

    return Mouse;

  })();

}).call(this);


/*  written by fc on 2017-04-25 */

(function() {
  Phacker.Game.Sprite = (function() {
    function Sprite(gm) {
      this.gm = gm;
      this._fle_ = 'Sprite';
      this.pm = this.gm.parameters.spt;
      this.pm.x0 = 10;
      this.pm.y0 = this.gm.parameters.pfm.y0 - 50;
      this.pm.w = 98;
      this.pm.h = 45;
      this.pm.g = 350;
      this.pm.vy = {
        low: -500,
        top: 120
      };
      this.pm.vy;
      this.pm.dvx0 = this.pm.vx0 / 1.5;
      this.pm.top = this.gm.gameOptions.fullscreen ? 140 : 90;
      this.pm.mes_emy = "not yet";
      this.spt = this.gm.add.sprite(this.pm.x0, this.pm.y0, 'character_sprite');
      this.gm.physics.arcade.enable(this.spt, Phaser.Physics.ARCADE);
      this.spt.body.setSize(25, 45, 5, 0);
      this.spt.body.bounce.y = 1;
      this.spt.body.gravity.y = this.pm.g;
      this.spt.body.velocity.x = this.pm.vx0;
      this.anim_spt = this.spt.animations.add('anim', [0, 1, 2, 3], 15, true);
      this.spt.animations.play('anim');
    }

    Sprite.prototype.collide_emy = function(emy) {
      var ref;
      if ((this.gm.parameters.pfm.w - 40 < (ref = this.spt.x) && ref < this.gm.parameters.pfm.w - 35)) {
        this.spt.body.velocity.y = this.pm.vy.low;
        console.log(this._fle_, ': ', this.gm.parameters.pfm.w - 20, this.spt.x, this.gm.parameters.pfm.w - 15);
      }
      if (this.spt.y < this.pm.top) {
        this.spt.body.velocity.y = this.pm.vy.top;
      }
      if (this.gm.physics.arcade.collide(this.spt, emy, function() {
        return true;
      }, function(spt, emy) {
        return this.when_collide_with_emy(spt, emy);
      }, this)) {
        return this.pm.mes_emy;
      }
      return 'nothing';
    };

    Sprite.prototype.when_collide_with_emy = function(spt, emy) {
      spt.body.velocity.y = -this.pm.vy.low;
      if (this.gm.math.fuzzyEqual(spt.y + this.pm.h, emy.y, 6)) {
        this.pm.mes_emy = 'good collision';
      } else {
        this.pm.mes_emy = 'bad collision';
      }
      return true;
    };

    return Sprite;

  })();

}).call(this);


/*  ecrit par fc le 2017-03-31 */

(function() {
  Phacker.Game.My_camera = (function() {
    function My_camera(gm) {
      this.gm = gm;
      this._fle_ = 'Camera';
      this.pm = this.gm.parameters.cam = {};
      this.pm = {
        offset: this.gm.gameOptions.fullscreen ? 60 : 100,
        speed: 4
      };
    }

    My_camera.prototype.move = function(spt, socle) {
      if (spt.x < this.gm.parameters.pfm.w) {
        return;
      }
      if ((this.gm.camera.x - spt.x + this.pm.offset) < -this.pm.speed) {
        return this.gm.camera.x += this.pm.speed;
      } else {
        return this.gm.camera.x = spt.x - this.pm.offset;
      }
    };

    return My_camera;

  })();

}).call(this);

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  this.YourGame = (function(superClass) {
    extend(YourGame, superClass);

    function YourGame() {
      return YourGame.__super__.constructor.apply(this, arguments);
    }

    YourGame.prototype.update = function() {
      var mess;
      YourGame.__super__.update.call(this);
      this._fle_ = 'Update';
      this.game.physics.arcade.collide(this.spriteO.spt, this.socleO.pfm);
      mess = this.spriteO.collide_emy(this.enemiesO.emy);
      this.cameraO.move(this.spriteO.spt, this.socleO);
      this.socleO.move_clouds(this.spriteO.spt);
      return this.enemiesO.create_destroy();
    };

    YourGame.prototype.resetPlayer = function() {
      return console.log("Reset the player");
    };

    YourGame.prototype.create = function() {
      YourGame.__super__.create.call(this);
      this.game.physics.startSystem(Phaser.Physics.ARCADE);
      this.game.world.setBounds(-1000, -1000, 300000, 2000);
      this.socleO = new Phacker.Game.Socle(this.game);
      this.enemiesO = new Phacker.Game.Enemies(this.game);
      this.spriteO = new Phacker.Game.Sprite(this.game);
      this.mouseO = new Phacker.Game.Mouse(this.game, this.spriteO.spt);
      return this.cameraO = new Phacker.Game.My_camera(this.game);
    };

    return YourGame;

  })(Phacker.GameState);


  /*  LOGIC OF YOUR GAME
   * Examples buttons actions
   *
  lostBtn = @game.add.text(0, 0, "Bad Action");
  lostBtn.inputEnabled = true;
  lostBtn.y = @game.height*0.5 - lostBtn.height*0.5
  lostBtn.events.onInputDown.add ( ->
      @lost()
  ).bind @
  
  winBtn = @game.add.text(0, 0, "Good Action");
  winBtn.inputEnabled = true;
  winBtn.y = @game.height*0.5 - winBtn.height*0.5
  winBtn.x = @game.width - winBtn.width
  winBtn.events.onInputDown.add ( ->
      @win()
  ).bind @
  
  lostLifeBtn = @game.add.text(0, 0, "Lost Life");
  lostLifeBtn.inputEnabled = true;
  lostLifeBtn.y = @game.height*0.5 - lostLifeBtn.height*0.5
  lostLifeBtn.x = @game.width*0.5 - lostLifeBtn.width*0.5
  lostLifeBtn.events.onInputDown.add ( ->
      @lostLife()
  ).bind @
  
  bonusBtn = @game.add.text(0, 0, "Bonus");
  bonusBtn.inputEnabled = true;
  bonusBtn.y = @game.height*0.5 - bonusBtn.height*0.5 + 50
  bonusBtn.x = @game.width - bonusBtn.width
  bonusBtn.events.onInputDown.add ( ->
      @winBonus()
  ).bind @
  
  #Placement specific for mobile
  
  if @game.gameOptions.fullscreen
          lostBtn.x = @game.width*0.5 - lostBtn.width*0.5
          lostBtn.y = @game.height*0.25
  
          winBtn.x = @game.width*0.5 - winBtn.width*0.5
          winBtn.y = @game.height*0.5
  
          lostLifeBtn.x = @game.width*0.5 - lostLifeBtn.width*0.5
          lostLifeBtn.y = @game.height*0.75
  
          bonusBtn.x = @game.width*0.5 - winBtn.width*0.5
          bonusBtn.y = @game.height*0.5 + 50
   */

}).call(this);
