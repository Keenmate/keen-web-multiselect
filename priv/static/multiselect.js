var ht = Object.defineProperty;
var mt = (o, e, t) => e in o ? ht(o, e, { enumerable: !0, configurable: !0, writable: !0, value: t }) : o[e] = t;
var d = (o, e, t) => mt(o, typeof e != "symbol" ? e + "" : e, t);
const ie = Math.min, F = Math.max, re = Math.round, se = Math.floor, L = (o) => ({
  x: o,
  y: o
}), pt = {
  left: "right",
  right: "left",
  bottom: "top",
  top: "bottom"
}, ut = {
  start: "end",
  end: "start"
};
function De(o, e, t) {
  return F(o, ie(e, t));
}
function le(o, e) {
  return typeof o == "function" ? o(e) : o;
}
function N(o) {
  return o.split("-")[0];
}
function ce(o) {
  return o.split("-")[1];
}
function Ge(o) {
  return o === "x" ? "y" : "x";
}
function Ke(o) {
  return o === "y" ? "height" : "width";
}
const bt = /* @__PURE__ */ new Set(["top", "bottom"]);
function V(o) {
  return bt.has(N(o)) ? "y" : "x";
}
function qe(o) {
  return Ge(V(o));
}
function gt(o, e, t) {
  t === void 0 && (t = !1);
  const s = ce(o), i = qe(o), r = Ke(i);
  let n = i === "x" ? s === (t ? "end" : "start") ? "right" : "left" : s === "start" ? "bottom" : "top";
  return e.reference[r] > e.floating[r] && (n = ne(n)), [n, ne(n)];
}
function ft(o) {
  const e = ne(o);
  return [fe(o), e, fe(e)];
}
function fe(o) {
  return o.replace(/start|end/g, (e) => ut[e]);
}
const ze = ["left", "right"], Ve = ["right", "left"], vt = ["top", "bottom"], _t = ["bottom", "top"];
function yt(o, e, t) {
  switch (o) {
    case "top":
    case "bottom":
      return t ? e ? Ve : ze : e ? ze : Ve;
    case "left":
    case "right":
      return e ? vt : _t;
    default:
      return [];
  }
}
function wt(o, e, t, s) {
  const i = ce(o);
  let r = yt(N(o), t === "start", s);
  return i && (r = r.map((n) => n + "-" + i), e && (r = r.concat(r.map(fe)))), r;
}
function ne(o) {
  return o.replace(/left|right|bottom|top/g, (e) => pt[e]);
}
function kt(o) {
  return {
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
    ...o
  };
}
function xt(o) {
  return typeof o != "number" ? kt(o) : {
    top: o,
    right: o,
    bottom: o,
    left: o
  };
}
function ae(o) {
  const {
    x: e,
    y: t,
    width: s,
    height: i
  } = o;
  return {
    width: s,
    height: i,
    top: t,
    left: e,
    right: e + s,
    bottom: t + i,
    x: e,
    y: t
  };
}
function Be(o, e, t) {
  let {
    reference: s,
    floating: i
  } = o;
  const r = V(e), n = qe(e), a = Ke(n), l = N(e), h = r === "y", c = s.x + s.width / 2 - i.width / 2, p = s.y + s.height / 2 - i.height / 2, u = s[a] / 2 - i[a] / 2;
  let m;
  switch (l) {
    case "top":
      m = {
        x: c,
        y: s.y - i.height
      };
      break;
    case "bottom":
      m = {
        x: c,
        y: s.y + s.height
      };
      break;
    case "right":
      m = {
        x: s.x + s.width,
        y: p
      };
      break;
    case "left":
      m = {
        x: s.x - i.width,
        y: p
      };
      break;
    default:
      m = {
        x: s.x,
        y: s.y
      };
  }
  switch (ce(e)) {
    case "start":
      m[n] -= u * (t && h ? -1 : 1);
      break;
    case "end":
      m[n] += u * (t && h ? -1 : 1);
      break;
  }
  return m;
}
const Ct = async (o, e, t) => {
  const {
    placement: s = "bottom",
    strategy: i = "absolute",
    middleware: r = [],
    platform: n
  } = t, a = r.filter(Boolean), l = await (n.isRTL == null ? void 0 : n.isRTL(e));
  let h = await n.getElementRects({
    reference: o,
    floating: e,
    strategy: i
  }), {
    x: c,
    y: p
  } = Be(h, s, l), u = s, m = {}, b = 0;
  for (let f = 0; f < a.length; f++) {
    const {
      name: g,
      fn: v
    } = a[f], {
      x: _,
      y: w,
      data: C,
      reset: k
    } = await v({
      x: c,
      y: p,
      initialPlacement: s,
      placement: u,
      strategy: i,
      middlewareData: m,
      rects: h,
      platform: n,
      elements: {
        reference: o,
        floating: e
      }
    });
    c = _ ?? c, p = w ?? p, m = {
      ...m,
      [g]: {
        ...m[g],
        ...C
      }
    }, k && b <= 50 && (b++, typeof k == "object" && (k.placement && (u = k.placement), k.rects && (h = k.rects === !0 ? await n.getElementRects({
      reference: o,
      floating: e,
      strategy: i
    }) : k.rects), {
      x: c,
      y: p
    } = Be(h, u, l)), f = -1);
  }
  return {
    x: c,
    y: p,
    placement: u,
    strategy: i,
    middlewareData: m
  };
};
async function Ye(o, e) {
  var t;
  e === void 0 && (e = {});
  const {
    x: s,
    y: i,
    platform: r,
    rects: n,
    elements: a,
    strategy: l
  } = o, {
    boundary: h = "clippingAncestors",
    rootBoundary: c = "viewport",
    elementContext: p = "floating",
    altBoundary: u = !1,
    padding: m = 0
  } = le(e, o), b = xt(m), g = a[u ? p === "floating" ? "reference" : "floating" : p], v = ae(await r.getClippingRect({
    element: (t = await (r.isElement == null ? void 0 : r.isElement(g))) == null || t ? g : g.contextElement || await (r.getDocumentElement == null ? void 0 : r.getDocumentElement(a.floating)),
    boundary: h,
    rootBoundary: c,
    strategy: l
  })), _ = p === "floating" ? {
    x: s,
    y: i,
    width: n.floating.width,
    height: n.floating.height
  } : n.reference, w = await (r.getOffsetParent == null ? void 0 : r.getOffsetParent(a.floating)), C = await (r.isElement == null ? void 0 : r.isElement(w)) ? await (r.getScale == null ? void 0 : r.getScale(w)) || {
    x: 1,
    y: 1
  } : {
    x: 1,
    y: 1
  }, k = ae(r.convertOffsetParentRelativeRectToViewportRelativeRect ? await r.convertOffsetParentRelativeRectToViewportRelativeRect({
    elements: a,
    rect: _,
    offsetParent: w,
    strategy: l
  }) : _);
  return {
    top: (v.top - k.top + b.top) / C.y,
    bottom: (k.bottom - v.bottom + b.bottom) / C.y,
    left: (v.left - k.left + b.left) / C.x,
    right: (k.right - v.right + b.right) / C.x
  };
}
const St = function(o) {
  return o === void 0 && (o = {}), {
    name: "flip",
    options: o,
    async fn(e) {
      var t, s;
      const {
        placement: i,
        middlewareData: r,
        rects: n,
        initialPlacement: a,
        platform: l,
        elements: h
      } = e, {
        mainAxis: c = !0,
        crossAxis: p = !0,
        fallbackPlacements: u,
        fallbackStrategy: m = "bestFit",
        fallbackAxisSideDirection: b = "none",
        flipAlignment: f = !0,
        ...g
      } = le(o, e);
      if ((t = r.arrow) != null && t.alignmentOffset)
        return {};
      const v = N(i), _ = V(a), w = N(a) === a, C = await (l.isRTL == null ? void 0 : l.isRTL(h.floating)), k = u || (w || !f ? [ne(a)] : ft(a)), Y = b !== "none";
      !u && Y && k.push(...wt(a, f, b, C));
      const j = [a, ...k], ue = await Ye(e, g), te = [];
      let U = ((s = r.flip) == null ? void 0 : s.overflows) || [];
      if (c && te.push(ue[v]), p) {
        const $ = gt(i, n, C);
        te.push(ue[$[0]], ue[$[1]]);
      }
      if (U = [...U, {
        placement: i,
        overflows: te
      }], !te.every(($) => $ <= 0)) {
        var Pe, Le;
        const $ = (((Pe = r.flip) == null ? void 0 : Pe.index) || 0) + 1, be = j[$];
        if (be && (!(p === "alignment" ? _ !== V(be) : !1) || // We leave the current main axis only if every placement on that axis
        // overflows the main axis.
        U.every((O) => V(O.placement) === _ ? O.overflows[0] > 0 : !0)))
          return {
            data: {
              index: $,
              overflows: U
            },
            reset: {
              placement: be
            }
          };
        let X = (Le = U.filter((R) => R.overflows[0] <= 0).sort((R, O) => R.overflows[1] - O.overflows[1])[0]) == null ? void 0 : Le.placement;
        if (!X)
          switch (m) {
            case "bestFit": {
              var Ee;
              const R = (Ee = U.filter((O) => {
                if (Y) {
                  const z = V(O.placement);
                  return z === _ || // Create a bias to the `y` side axis due to horizontal
                  // reading directions favoring greater width.
                  z === "y";
                }
                return !0;
              }).map((O) => [O.placement, O.overflows.filter((z) => z > 0).reduce((z, dt) => z + dt, 0)]).sort((O, z) => O[1] - z[1])[0]) == null ? void 0 : Ee[0];
              R && (X = R);
              break;
            }
            case "initialPlacement":
              X = a;
              break;
          }
        if (i !== X)
          return {
            reset: {
              placement: X
            }
          };
      }
      return {};
    }
  };
}, Tt = /* @__PURE__ */ new Set(["left", "top"]);
async function Ot(o, e) {
  const {
    placement: t,
    platform: s,
    elements: i
  } = o, r = await (s.isRTL == null ? void 0 : s.isRTL(i.floating)), n = N(t), a = ce(t), l = V(t) === "y", h = Tt.has(n) ? -1 : 1, c = r && l ? -1 : 1, p = le(e, o);
  let {
    mainAxis: u,
    crossAxis: m,
    alignmentAxis: b
  } = typeof p == "number" ? {
    mainAxis: p,
    crossAxis: 0,
    alignmentAxis: null
  } : {
    mainAxis: p.mainAxis || 0,
    crossAxis: p.crossAxis || 0,
    alignmentAxis: p.alignmentAxis
  };
  return a && typeof b == "number" && (m = a === "end" ? b * -1 : b), l ? {
    x: m * c,
    y: u * h
  } : {
    x: u * h,
    y: m * c
  };
}
const It = function(o) {
  return o === void 0 && (o = 0), {
    name: "offset",
    options: o,
    async fn(e) {
      var t, s;
      const {
        x: i,
        y: r,
        placement: n,
        middlewareData: a
      } = e, l = await Ot(e, o);
      return n === ((t = a.offset) == null ? void 0 : t.placement) && (s = a.arrow) != null && s.alignmentOffset ? {} : {
        x: i + l.x,
        y: r + l.y,
        data: {
          ...l,
          placement: n
        }
      };
    }
  };
}, At = function(o) {
  return o === void 0 && (o = {}), {
    name: "shift",
    options: o,
    async fn(e) {
      const {
        x: t,
        y: s,
        placement: i
      } = e, {
        mainAxis: r = !0,
        crossAxis: n = !1,
        limiter: a = {
          fn: (g) => {
            let {
              x: v,
              y: _
            } = g;
            return {
              x: v,
              y: _
            };
          }
        },
        ...l
      } = le(o, e), h = {
        x: t,
        y: s
      }, c = await Ye(e, l), p = V(N(i)), u = Ge(p);
      let m = h[u], b = h[p];
      if (r) {
        const g = u === "y" ? "top" : "left", v = u === "y" ? "bottom" : "right", _ = m + c[g], w = m - c[v];
        m = De(_, m, w);
      }
      if (n) {
        const g = p === "y" ? "top" : "left", v = p === "y" ? "bottom" : "right", _ = b + c[g], w = b - c[v];
        b = De(_, b, w);
      }
      const f = a.fn({
        ...e,
        [u]: m,
        [p]: b
      });
      return {
        ...f,
        data: {
          x: f.x - t,
          y: f.y - s,
          enabled: {
            [u]: r,
            [p]: n
          }
        }
      };
    }
  };
};
function de() {
  return typeof window < "u";
}
function q(o) {
  return Xe(o) ? (o.nodeName || "").toLowerCase() : "#document";
}
function T(o) {
  var e;
  return (o == null || (e = o.ownerDocument) == null ? void 0 : e.defaultView) || window;
}
function D(o) {
  var e;
  return (e = (Xe(o) ? o.ownerDocument : o.document) || window.document) == null ? void 0 : e.documentElement;
}
function Xe(o) {
  return de() ? o instanceof Node || o instanceof T(o).Node : !1;
}
function A(o) {
  return de() ? o instanceof Element || o instanceof T(o).Element : !1;
}
function E(o) {
  return de() ? o instanceof HTMLElement || o instanceof T(o).HTMLElement : !1;
}
function $e(o) {
  return !de() || typeof ShadowRoot > "u" ? !1 : o instanceof ShadowRoot || o instanceof T(o).ShadowRoot;
}
const Mt = /* @__PURE__ */ new Set(["inline", "contents"]);
function ee(o) {
  const {
    overflow: e,
    overflowX: t,
    overflowY: s,
    display: i
  } = M(o);
  return /auto|scroll|overlay|hidden|clip/.test(e + s + t) && !Mt.has(i);
}
const Pt = /* @__PURE__ */ new Set(["table", "td", "th"]);
function Lt(o) {
  return Pt.has(q(o));
}
const Et = [":popover-open", ":modal"];
function he(o) {
  return Et.some((e) => {
    try {
      return o.matches(e);
    } catch {
      return !1;
    }
  });
}
const Dt = ["transform", "translate", "scale", "rotate", "perspective"], zt = ["transform", "translate", "scale", "rotate", "perspective", "filter"], Vt = ["paint", "layout", "strict", "content"];
function Te(o) {
  const e = Oe(), t = A(o) ? M(o) : o;
  return Dt.some((s) => t[s] ? t[s] !== "none" : !1) || (t.containerType ? t.containerType !== "normal" : !1) || !e && (t.backdropFilter ? t.backdropFilter !== "none" : !1) || !e && (t.filter ? t.filter !== "none" : !1) || zt.some((s) => (t.willChange || "").includes(s)) || Vt.some((s) => (t.contain || "").includes(s));
}
function Bt(o) {
  let e = B(o);
  for (; E(e) && !K(e); ) {
    if (Te(e))
      return e;
    if (he(e))
      return null;
    e = B(e);
  }
  return null;
}
function Oe() {
  return typeof CSS > "u" || !CSS.supports ? !1 : CSS.supports("-webkit-backdrop-filter", "none");
}
const $t = /* @__PURE__ */ new Set(["html", "body", "#document"]);
function K(o) {
  return $t.has(q(o));
}
function M(o) {
  return T(o).getComputedStyle(o);
}
function me(o) {
  return A(o) ? {
    scrollLeft: o.scrollLeft,
    scrollTop: o.scrollTop
  } : {
    scrollLeft: o.scrollX,
    scrollTop: o.scrollY
  };
}
function B(o) {
  if (q(o) === "html")
    return o;
  const e = (
    // Step into the shadow DOM of the parent of a slotted node.
    o.assignedSlot || // DOM Element detected.
    o.parentNode || // ShadowRoot detected.
    $e(o) && o.host || // Fallback.
    D(o)
  );
  return $e(e) ? e.host : e;
}
function Je(o) {
  const e = B(o);
  return K(e) ? o.ownerDocument ? o.ownerDocument.body : o.body : E(e) && ee(e) ? e : Je(e);
}
function Z(o, e, t) {
  var s;
  e === void 0 && (e = []), t === void 0 && (t = !0);
  const i = Je(o), r = i === ((s = o.ownerDocument) == null ? void 0 : s.body), n = T(i);
  if (r) {
    const a = ve(n);
    return e.concat(n, n.visualViewport || [], ee(i) ? i : [], a && t ? Z(a) : []);
  }
  return e.concat(i, Z(i, [], t));
}
function ve(o) {
  return o.parent && Object.getPrototypeOf(o.parent) ? o.frameElement : null;
}
function Ze(o) {
  const e = M(o);
  let t = parseFloat(e.width) || 0, s = parseFloat(e.height) || 0;
  const i = E(o), r = i ? o.offsetWidth : t, n = i ? o.offsetHeight : s, a = re(t) !== r || re(s) !== n;
  return a && (t = r, s = n), {
    width: t,
    height: s,
    $: a
  };
}
function Ie(o) {
  return A(o) ? o : o.contextElement;
}
function G(o) {
  const e = Ie(o);
  if (!E(e))
    return L(1);
  const t = e.getBoundingClientRect(), {
    width: s,
    height: i,
    $: r
  } = Ze(e);
  let n = (r ? re(t.width) : t.width) / s, a = (r ? re(t.height) : t.height) / i;
  return (!n || !Number.isFinite(n)) && (n = 1), (!a || !Number.isFinite(a)) && (a = 1), {
    x: n,
    y: a
  };
}
const Rt = /* @__PURE__ */ L(0);
function Qe(o) {
  const e = T(o);
  return !Oe() || !e.visualViewport ? Rt : {
    x: e.visualViewport.offsetLeft,
    y: e.visualViewport.offsetTop
  };
}
function Ht(o, e, t) {
  return e === void 0 && (e = !1), !t || e && t !== T(o) ? !1 : e;
}
function W(o, e, t, s) {
  e === void 0 && (e = !1), t === void 0 && (t = !1);
  const i = o.getBoundingClientRect(), r = Ie(o);
  let n = L(1);
  e && (s ? A(s) && (n = G(s)) : n = G(o));
  const a = Ht(r, t, s) ? Qe(r) : L(0);
  let l = (i.left + a.x) / n.x, h = (i.top + a.y) / n.y, c = i.width / n.x, p = i.height / n.y;
  if (r) {
    const u = T(r), m = s && A(s) ? T(s) : s;
    let b = u, f = ve(b);
    for (; f && s && m !== b; ) {
      const g = G(f), v = f.getBoundingClientRect(), _ = M(f), w = v.left + (f.clientLeft + parseFloat(_.paddingLeft)) * g.x, C = v.top + (f.clientTop + parseFloat(_.paddingTop)) * g.y;
      l *= g.x, h *= g.y, c *= g.x, p *= g.y, l += w, h += C, b = T(f), f = ve(b);
    }
  }
  return ae({
    width: c,
    height: p,
    x: l,
    y: h
  });
}
function pe(o, e) {
  const t = me(o).scrollLeft;
  return e ? e.left + t : W(D(o)).left + t;
}
function et(o, e) {
  const t = o.getBoundingClientRect(), s = t.left + e.scrollLeft - pe(o, t), i = t.top + e.scrollTop;
  return {
    x: s,
    y: i
  };
}
function Ft(o) {
  let {
    elements: e,
    rect: t,
    offsetParent: s,
    strategy: i
  } = o;
  const r = i === "fixed", n = D(s), a = e ? he(e.floating) : !1;
  if (s === n || a && r)
    return t;
  let l = {
    scrollLeft: 0,
    scrollTop: 0
  }, h = L(1);
  const c = L(0), p = E(s);
  if ((p || !p && !r) && ((q(s) !== "body" || ee(n)) && (l = me(s)), E(s))) {
    const m = W(s);
    h = G(s), c.x = m.x + s.clientLeft, c.y = m.y + s.clientTop;
  }
  const u = n && !p && !r ? et(n, l) : L(0);
  return {
    width: t.width * h.x,
    height: t.height * h.y,
    x: t.x * h.x - l.scrollLeft * h.x + c.x + u.x,
    y: t.y * h.y - l.scrollTop * h.y + c.y + u.y
  };
}
function Nt(o) {
  return Array.from(o.getClientRects());
}
function Wt(o) {
  const e = D(o), t = me(o), s = o.ownerDocument.body, i = F(e.scrollWidth, e.clientWidth, s.scrollWidth, s.clientWidth), r = F(e.scrollHeight, e.clientHeight, s.scrollHeight, s.clientHeight);
  let n = -t.scrollLeft + pe(o);
  const a = -t.scrollTop;
  return M(s).direction === "rtl" && (n += F(e.clientWidth, s.clientWidth) - i), {
    width: i,
    height: r,
    x: n,
    y: a
  };
}
const Re = 25;
function jt(o, e) {
  const t = T(o), s = D(o), i = t.visualViewport;
  let r = s.clientWidth, n = s.clientHeight, a = 0, l = 0;
  if (i) {
    r = i.width, n = i.height;
    const c = Oe();
    (!c || c && e === "fixed") && (a = i.offsetLeft, l = i.offsetTop);
  }
  const h = pe(s);
  if (h <= 0) {
    const c = s.ownerDocument, p = c.body, u = getComputedStyle(p), m = c.compatMode === "CSS1Compat" && parseFloat(u.marginLeft) + parseFloat(u.marginRight) || 0, b = Math.abs(s.clientWidth - p.clientWidth - m);
    b <= Re && (r -= b);
  } else h <= Re && (r += h);
  return {
    width: r,
    height: n,
    x: a,
    y: l
  };
}
const Ut = /* @__PURE__ */ new Set(["absolute", "fixed"]);
function Gt(o, e) {
  const t = W(o, !0, e === "fixed"), s = t.top + o.clientTop, i = t.left + o.clientLeft, r = E(o) ? G(o) : L(1), n = o.clientWidth * r.x, a = o.clientHeight * r.y, l = i * r.x, h = s * r.y;
  return {
    width: n,
    height: a,
    x: l,
    y: h
  };
}
function He(o, e, t) {
  let s;
  if (e === "viewport")
    s = jt(o, t);
  else if (e === "document")
    s = Wt(D(o));
  else if (A(e))
    s = Gt(e, t);
  else {
    const i = Qe(o);
    s = {
      x: e.x - i.x,
      y: e.y - i.y,
      width: e.width,
      height: e.height
    };
  }
  return ae(s);
}
function tt(o, e) {
  const t = B(o);
  return t === e || !A(t) || K(t) ? !1 : M(t).position === "fixed" || tt(t, e);
}
function Kt(o, e) {
  const t = e.get(o);
  if (t)
    return t;
  let s = Z(o, [], !1).filter((a) => A(a) && q(a) !== "body"), i = null;
  const r = M(o).position === "fixed";
  let n = r ? B(o) : o;
  for (; A(n) && !K(n); ) {
    const a = M(n), l = Te(n);
    !l && a.position === "fixed" && (i = null), (r ? !l && !i : !l && a.position === "static" && !!i && Ut.has(i.position) || ee(n) && !l && tt(o, n)) ? s = s.filter((c) => c !== n) : i = a, n = B(n);
  }
  return e.set(o, s), s;
}
function qt(o) {
  let {
    element: e,
    boundary: t,
    rootBoundary: s,
    strategy: i
  } = o;
  const n = [...t === "clippingAncestors" ? he(e) ? [] : Kt(e, this._c) : [].concat(t), s], a = n[0], l = n.reduce((h, c) => {
    const p = He(e, c, i);
    return h.top = F(p.top, h.top), h.right = ie(p.right, h.right), h.bottom = ie(p.bottom, h.bottom), h.left = F(p.left, h.left), h;
  }, He(e, a, i));
  return {
    width: l.right - l.left,
    height: l.bottom - l.top,
    x: l.left,
    y: l.top
  };
}
function Yt(o) {
  const {
    width: e,
    height: t
  } = Ze(o);
  return {
    width: e,
    height: t
  };
}
function Xt(o, e, t) {
  const s = E(e), i = D(e), r = t === "fixed", n = W(o, !0, r, e);
  let a = {
    scrollLeft: 0,
    scrollTop: 0
  };
  const l = L(0);
  function h() {
    l.x = pe(i);
  }
  if (s || !s && !r)
    if ((q(e) !== "body" || ee(i)) && (a = me(e)), s) {
      const m = W(e, !0, r, e);
      l.x = m.x + e.clientLeft, l.y = m.y + e.clientTop;
    } else i && h();
  r && !s && i && h();
  const c = i && !s && !r ? et(i, a) : L(0), p = n.left + a.scrollLeft - l.x - c.x, u = n.top + a.scrollTop - l.y - c.y;
  return {
    x: p,
    y: u,
    width: n.width,
    height: n.height
  };
}
function ge(o) {
  return M(o).position === "static";
}
function Fe(o, e) {
  if (!E(o) || M(o).position === "fixed")
    return null;
  if (e)
    return e(o);
  let t = o.offsetParent;
  return D(o) === t && (t = t.ownerDocument.body), t;
}
function st(o, e) {
  const t = T(o);
  if (he(o))
    return t;
  if (!E(o)) {
    let i = B(o);
    for (; i && !K(i); ) {
      if (A(i) && !ge(i))
        return i;
      i = B(i);
    }
    return t;
  }
  let s = Fe(o, e);
  for (; s && Lt(s) && ge(s); )
    s = Fe(s, e);
  return s && K(s) && ge(s) && !Te(s) ? t : s || Bt(o) || t;
}
const Jt = async function(o) {
  const e = this.getOffsetParent || st, t = this.getDimensions, s = await t(o.floating);
  return {
    reference: Xt(o.reference, await e(o.floating), o.strategy),
    floating: {
      x: 0,
      y: 0,
      width: s.width,
      height: s.height
    }
  };
};
function Zt(o) {
  return M(o).direction === "rtl";
}
const ot = {
  convertOffsetParentRelativeRectToViewportRelativeRect: Ft,
  getDocumentElement: D,
  getClippingRect: qt,
  getOffsetParent: st,
  getElementRects: Jt,
  getClientRects: Nt,
  getDimensions: Yt,
  getScale: G,
  isElement: A,
  isRTL: Zt
};
function it(o, e) {
  return o.x === e.x && o.y === e.y && o.width === e.width && o.height === e.height;
}
function Qt(o, e) {
  let t = null, s;
  const i = D(o);
  function r() {
    var a;
    clearTimeout(s), (a = t) == null || a.disconnect(), t = null;
  }
  function n(a, l) {
    a === void 0 && (a = !1), l === void 0 && (l = 1), r();
    const h = o.getBoundingClientRect(), {
      left: c,
      top: p,
      width: u,
      height: m
    } = h;
    if (a || e(), !u || !m)
      return;
    const b = se(p), f = se(i.clientWidth - (c + u)), g = se(i.clientHeight - (p + m)), v = se(c), w = {
      rootMargin: -b + "px " + -f + "px " + -g + "px " + -v + "px",
      threshold: F(0, ie(1, l)) || 1
    };
    let C = !0;
    function k(Y) {
      const j = Y[0].intersectionRatio;
      if (j !== l) {
        if (!C)
          return n();
        j ? n(!1, j) : s = setTimeout(() => {
          n(!1, 1e-7);
        }, 1e3);
      }
      j === 1 && !it(h, o.getBoundingClientRect()) && n(), C = !1;
    }
    try {
      t = new IntersectionObserver(k, {
        ...w,
        // Handle <iframe>s
        root: i.ownerDocument
      });
    } catch {
      t = new IntersectionObserver(k, w);
    }
    t.observe(o);
  }
  return n(!0), r;
}
function _e(o, e, t, s) {
  s === void 0 && (s = {});
  const {
    ancestorScroll: i = !0,
    ancestorResize: r = !0,
    elementResize: n = typeof ResizeObserver == "function",
    layoutShift: a = typeof IntersectionObserver == "function",
    animationFrame: l = !1
  } = s, h = Ie(o), c = i || r ? [...h ? Z(h) : [], ...Z(e)] : [];
  c.forEach((v) => {
    i && v.addEventListener("scroll", t, {
      passive: !0
    }), r && v.addEventListener("resize", t);
  });
  const p = h && a ? Qt(h, t) : null;
  let u = -1, m = null;
  n && (m = new ResizeObserver((v) => {
    let [_] = v;
    _ && _.target === h && m && (m.unobserve(e), cancelAnimationFrame(u), u = requestAnimationFrame(() => {
      var w;
      (w = m) == null || w.observe(e);
    })), t();
  }), h && !l && m.observe(h), m.observe(e));
  let b, f = l ? W(o) : null;
  l && g();
  function g() {
    const v = W(o);
    f && !it(f, v) && t(), f = v, b = requestAnimationFrame(g);
  }
  return t(), () => {
    var v;
    c.forEach((_) => {
      i && _.removeEventListener("scroll", t), r && _.removeEventListener("resize", t);
    }), p == null || p(), (v = m) == null || v.disconnect(), m = null, l && cancelAnimationFrame(b);
  };
}
const ye = It, we = At, rt = St, ke = (o, e, t) => {
  const s = /* @__PURE__ */ new Map(), i = {
    platform: ot,
    ...t
  }, r = {
    ...i.platform,
    _c: s
  };
  return Ct(o, e, {
    ...i,
    platform: r
  });
};
var nt = function() {
}, I = "undefined", es = typeof window !== I && typeof window.navigator !== I && /Trident\/|MSIE /.test(window.navigator.userAgent), xe = [
  "trace",
  "debug",
  "info",
  "warn",
  "error"
], Q = {}, y = null;
function Ne(o, e) {
  var t = o[e];
  if (typeof t.bind == "function")
    return t.bind(o);
  try {
    return Function.prototype.bind.call(t, o);
  } catch {
    return function() {
      return Function.prototype.apply.apply(t, [o, arguments]);
    };
  }
}
function ts() {
  console.log && (console.log.apply ? console.log.apply(console, arguments) : Function.prototype.apply.apply(console.log, [console, arguments])), console.trace && console.trace();
}
function ss(o) {
  return o === "debug" && (o = "log"), typeof console === I ? !1 : o === "trace" && es ? ts : console[o] !== void 0 ? Ne(console, o) : console.log !== void 0 ? Ne(console, "log") : nt;
}
function J() {
  for (var o = this.getLevel(), e = 0; e < xe.length; e++) {
    var t = xe[e];
    this[t] = e < o ? nt : this.methodFactory(t, o, this.name);
  }
  if (this.log = this.debug, typeof console === I && o < this.levels.SILENT)
    return "No console available for logging";
}
function os(o) {
  return function() {
    typeof console !== I && (J.call(this), this[o].apply(this, arguments));
  };
}
function is(o, e, t) {
  return ss(o) || os.apply(this, arguments);
}
function at(o, e) {
  var t = this, s, i, r, n = "loglevel";
  typeof o == "string" ? n += ":" + o : typeof o == "symbol" && (n = void 0);
  function a(u) {
    var m = (xe[u] || "silent").toUpperCase();
    if (!(typeof window === I || !n)) {
      try {
        window.localStorage[n] = m;
        return;
      } catch {
      }
      try {
        window.document.cookie = encodeURIComponent(n) + "=" + m + ";";
      } catch {
      }
    }
  }
  function l() {
    var u;
    if (!(typeof window === I || !n)) {
      try {
        u = window.localStorage[n];
      } catch {
      }
      if (typeof u === I)
        try {
          var m = window.document.cookie, b = encodeURIComponent(n), f = m.indexOf(b + "=");
          f !== -1 && (u = /^([^;]+)/.exec(
            m.slice(f + b.length + 1)
          )[1]);
        } catch {
        }
      return t.levels[u] === void 0 && (u = void 0), u;
    }
  }
  function h() {
    if (!(typeof window === I || !n)) {
      try {
        window.localStorage.removeItem(n);
      } catch {
      }
      try {
        window.document.cookie = encodeURIComponent(n) + "=; expires=Thu, 01 Jan 1970 00:00:00 UTC";
      } catch {
      }
    }
  }
  function c(u) {
    var m = u;
    if (typeof m == "string" && t.levels[m.toUpperCase()] !== void 0 && (m = t.levels[m.toUpperCase()]), typeof m == "number" && m >= 0 && m <= t.levels.SILENT)
      return m;
    throw new TypeError("log.setLevel() called with invalid level: " + u);
  }
  t.name = o, t.levels = {
    TRACE: 0,
    DEBUG: 1,
    INFO: 2,
    WARN: 3,
    ERROR: 4,
    SILENT: 5
  }, t.methodFactory = e || is, t.getLevel = function() {
    return r ?? i ?? s;
  }, t.setLevel = function(u, m) {
    return r = c(u), m !== !1 && a(r), J.call(t);
  }, t.setDefaultLevel = function(u) {
    i = c(u), l() || t.setLevel(u, !1);
  }, t.resetLevel = function() {
    r = null, h(), J.call(t);
  }, t.enableAll = function(u) {
    t.setLevel(t.levels.TRACE, u);
  }, t.disableAll = function(u) {
    t.setLevel(t.levels.SILENT, u);
  }, t.rebuild = function() {
    if (y !== t && (s = c(y.getLevel())), J.call(t), y === t)
      for (var u in Q)
        Q[u].rebuild();
  }, s = c(
    y ? y.getLevel() : "WARN"
  );
  var p = l();
  p != null && (r = c(p)), J.call(t);
}
y = new at();
y.getLogger = function(e) {
  if (typeof e != "symbol" && typeof e != "string" || e === "")
    throw new TypeError("You must supply a name when creating a logger.");
  var t = Q[e];
  return t || (t = Q[e] = new at(
    e,
    y.methodFactory
  )), t;
};
var rs = typeof window !== I ? window.log : void 0;
y.noConflict = function() {
  return typeof window !== I && window.log === y && (window.log = rs), y;
};
y.getLoggers = function() {
  return Q;
};
y.default = y;
var ns = function(o) {
  for (var e = 1, t = arguments.length, s; e < t; e++)
    for (s in arguments[e])
      Object.prototype.hasOwnProperty.call(arguments[e], s) && (o[s] = arguments[e][s]);
  return o;
}, as = {
  template: "[%t] %l:",
  levelFormatter: function(o) {
    return o.toUpperCase();
  },
  nameFormatter: function(o) {
    return o || "root";
  },
  timestampFormatter: function(o) {
    return o.toTimeString().replace(/.*(\d{2}:\d{2}:\d{2}).*/, "$1");
  },
  format: void 0
}, lt, H = {}, ls = function(o) {
  if (!o || !o.getLogger)
    throw new TypeError("Argument is not a root logger");
  lt = o;
}, cs = function(o, e) {
  if (!o || !o.setLevel)
    throw new TypeError("Argument is not a logger");
  var t = o.methodFactory, s = o.name || "", i = H[s] || H[""] || as;
  function r(n, a, l) {
    var h = t(n, a, l), c = H[l] || H[""], p = c.template.indexOf("%t") !== -1, u = c.template.indexOf("%l") !== -1, m = c.template.indexOf("%n") !== -1;
    return function() {
      for (var b = "", f = arguments.length, g = Array(f), v = 0; v < f; v++)
        g[v] = arguments[v];
      if (s || !H[l]) {
        var _ = c.timestampFormatter(/* @__PURE__ */ new Date()), w = c.levelFormatter(n), C = c.nameFormatter(l);
        c.format ? b += c.format(w, C, _) : (b += c.template, p && (b = b.replace(/%t/, _)), u && (b = b.replace(/%l/, w)), m && (b = b.replace(/%n/, C))), g.length && typeof g[0] == "string" ? g[0] = b + " " + g[0] : g.unshift(b);
      }
      h.apply(void 0, g);
    };
  }
  return H[s] || (o.methodFactory = r), e = e || {}, e.template && (e.format = void 0), H[s] = ns({}, i, e), o.setLevel(o.getLevel()), lt || o.warn(
    "It is necessary to call the function reg() of loglevel-plugin-prefix before calling apply. From the next release, it will throw an error. See more: https://github.com/kutuluk/loglevel-plugin-prefix/blob/master/README.md"
  ), o;
}, ds = {
  reg: ls,
  apply: cs
};
const hs = {
  debug: "#0ea5e9",
  // Blue
  info: "#10b981",
  // Green
  warn: "#f59e0b",
  // Orange
  error: "#ef4444"
  // Red
};
ds.reg(y);
const ms = (o) => o.toTimeString().split(" ")[0] + "." + o.getMilliseconds().toString().padStart(3, "0"), ps = y.methodFactory;
y.methodFactory = function(o, e, t) {
  const s = ps(o, e, t), r = `color: ${hs[o] || "#666"}; font-weight: bold;`, n = "color: inherit;";
  return function(...a) {
    const l = ms(/* @__PURE__ */ new Date()), h = o.toUpperCase(), c = t ? `%c[${l}]%c %c[${h}]%c %c[${t}]%c` : `%c[${l}]%c %c[${h}]%c`;
    s(c, ...t ? [r, n, r, n, r, n] : [r, n, r, n], ...a);
  };
};
typeof y.setDefaultLevel == "function" ? y.setDefaultLevel("silent") : y.setLevel("silent", !1);
const oe = y.getLogger("MULTISELECT:INIT"), x = y.getLogger("MULTISELECT:DATA"), P = y.getLogger("MULTISELECT:UI"), S = y.getLogger("MULTISELECT:INTERACTION"), us = [
  "MULTISELECT:INIT",
  "MULTISELECT:DATA",
  "MULTISELECT:UI",
  "MULTISELECT:INTERACTION"
];
function Ae() {
  typeof y.rebuild == "function" && y.rebuild();
}
function bs() {
  y.setLevel("debug"), Ae();
}
function gs() {
  y.setLevel("silent"), Ae();
}
function fs(o) {
  y.setLevel(o), Ae();
}
function vs(o, e) {
  const t = o.includes(":") ? o : `MULTISELECT:${o}`;
  y.getLogger(t).setLevel(e);
}
class We {
  constructor(e) {
    d(this, "container");
    d(this, "wrapper");
    d(this, "viewport");
    d(this, "itemHeight");
    d(this, "items");
    d(this, "renderItem");
    d(this, "bufferSize");
    d(this, "onVisibleRangeChange");
    d(this, "onScroll");
    d(this, "scrollTop", 0);
    d(this, "viewportHeight", 0);
    d(this, "visibleStart", 0);
    d(this, "visibleEnd", 0);
    d(this, "scrollHandler");
    d(this, "resizeObserver");
    this.container = e.container, this.itemHeight = e.itemHeight, this.items = e.items, this.renderItem = e.renderItem, this.bufferSize = e.bufferSize ?? 10, this.onVisibleRangeChange = e.onVisibleRangeChange, this.onScroll = e.onScroll, this.scrollHandler = this.handleScroll.bind(this), this.init();
  }
  /**
   * Initialize virtual scroll DOM structure
   *
   * Structure:
   * container (overflow-y: auto)
   *   └─ wrapper (height: totalItems * itemHeight)
   *      └─ viewport (position: absolute, top: 0)
   *         └─ items (position: absolute, top: index * itemHeight)
   */
  init() {
    this.container.innerHTML = "", this.wrapper = document.createElement("div"), this.wrapper.style.position = "relative", this.wrapper.style.width = "100%", this.wrapper.style.height = `${this.items.length * this.itemHeight}px`, this.wrapper.className = "ms__virtual-scroll-wrapper", this.viewport = document.createElement("div"), this.viewport.style.position = "absolute", this.viewport.style.top = "0", this.viewport.style.left = "0", this.viewport.style.right = "0", this.viewport.style.width = "100%", this.viewport.className = "ms__virtual-scroll-viewport", this.wrapper.appendChild(this.viewport), this.container.appendChild(this.wrapper), this.container.addEventListener("scroll", this.scrollHandler), typeof ResizeObserver < "u" && (this.resizeObserver = new ResizeObserver(() => {
      this.updateViewportHeight(), this.render();
    }), this.resizeObserver.observe(this.container)), this.updateViewportHeight(), this.render();
  }
  /**
   * Update viewport height (visible area)
   */
  updateViewportHeight() {
    const e = this.container.clientHeight;
    e > 0 && (this.viewportHeight = e);
  }
  /**
   * Handle scroll event
   */
  handleScroll() {
    this.scrollTop = this.container.scrollTop, this.onScroll && this.onScroll(this.scrollTop), this.render();
  }
  /**
   * Calculate visible range based on scroll position
   */
  calculateVisibleRange() {
    const e = Math.floor(this.scrollTop / this.itemHeight), t = Math.ceil((this.scrollTop + this.viewportHeight) / this.itemHeight), s = Math.max(0, e - this.bufferSize), i = Math.min(this.items.length, t + this.bufferSize);
    return { start: s, end: i };
  }
  /**
   * Render visible items
   */
  render() {
    const { start: e, end: t } = this.calculateVisibleRange();
    if (e === this.visibleStart && t === this.visibleEnd)
      return;
    this.visibleStart = e, this.visibleEnd = t, this.onVisibleRangeChange && this.onVisibleRangeChange(e, t);
    let s = "";
    for (let i = e; i < t; i++) {
      const r = this.items[i], n = this.renderItem(r, i), a = i * this.itemHeight;
      s += `<div class="ms__virtual-item" style="position: absolute; top: ${a}px; left: 0; right: 0; height: ${this.itemHeight}px;" data-index="${i}">`, s += n, s += "</div>";
    }
    this.viewport.innerHTML = s;
  }
  /**
   * Update items and re-render
   */
  setItems(e) {
    const t = e !== this.items || e.length !== this.items.length;
    this.items = e, this.wrapper.style.height = `${e.length * this.itemHeight}px`, this.updateViewportHeight(), t && (this.scrollTop = 0, this.container.scrollTop = 0), this.visibleStart = -1, this.visibleEnd = -1, this.render();
  }
  /**
   * Scroll to make item at index visible (like scrollIntoView with block: 'nearest')
   * Only scrolls if item is outside visible area, and scrolls minimally
   */
  scrollToIndex(e) {
    if (e < 0 || e >= this.items.length)
      return;
    const t = e * this.itemHeight, s = t + this.itemHeight, i = this.container.scrollTop, r = i + this.viewportHeight;
    t < i ? this.container.scrollTop = t : s > r && (this.container.scrollTop = s - this.viewportHeight);
  }
  /**
   * Get currently visible range
   */
  getVisibleRange() {
    return { start: this.visibleStart, end: this.visibleEnd };
  }
  /**
   * Get total number of items
   */
  getItemCount() {
    return this.items.length;
  }
  /**
   * Update item height and re-render
   */
  setItemHeight(e) {
    this.itemHeight = e, this.wrapper.style.height = `${this.items.length * e}px`, this.visibleStart = -1, this.visibleEnd = -1, this.render();
  }
  /**
   * Update buffer size
   */
  setBufferSize(e) {
    this.bufferSize = e, this.visibleStart = -1, this.visibleEnd = -1, this.render();
  }
  /**
   * Refresh/force re-render
   */
  refresh() {
    this.visibleStart = -1, this.visibleEnd = -1, this.render();
  }
  /**
   * Cleanup and remove event listeners
   */
  destroy() {
    this.container.removeEventListener("scroll", this.scrollHandler), this.resizeObserver && this.resizeObserver.disconnect(), this.container.innerHTML = "";
  }
}
class _s {
  constructor(e) {
    d(this, "element");
    d(this, "trigger");
    d(this, "container");
    d(this, "placement");
    d(this, "offsetDistance");
    d(this, "showDelay");
    d(this, "hideDelay");
    d(this, "visibleClass");
    d(this, "followCursor");
    d(this, "onBeforeShow");
    d(this, "showTimer", null);
    d(this, "hideTimer", null);
    d(this, "positionCleanup", null);
    d(this, "visible", !1);
    d(this, "cursorX", 0);
    d(this, "cursorY", 0);
    d(this, "handleMouseEnter");
    d(this, "handleMouseLeave");
    d(this, "handleMouseMove");
    this.trigger = e.trigger, this.container = e.container, this.placement = e.placement ?? "top", this.offsetDistance = e.offsetDistance ?? 8, this.showDelay = e.showDelay ?? 100, this.hideDelay = e.hideDelay ?? 100, this.visibleClass = e.visibleClass ?? "ms__badge-tooltip--visible", this.followCursor = e.followCursor ?? !1, this.onBeforeShow = e.onBeforeShow, this.element = document.createElement("div"), this.element.className = e.cssClass ?? "ms__badge-tooltip", typeof e.content == "string" ? this.element.textContent = e.content : this.element.appendChild(e.content), this.container.appendChild(this.element), this.handleMouseEnter = (t) => {
      this.followCursor && (this.cursorX = t.clientX, this.cursorY = t.clientY), this.scheduleShow();
    }, this.handleMouseLeave = () => this.scheduleHide(), this.trigger.addEventListener("mouseenter", this.handleMouseEnter), this.trigger.addEventListener("mouseleave", this.handleMouseLeave), this.followCursor && (this.handleMouseMove = (t) => {
      this.cursorX = t.clientX, this.cursorY = t.clientY, this.visible && this.positionAtCursor();
    }, this.trigger.addEventListener("mousemove", this.handleMouseMove));
  }
  scheduleShow() {
    this.hideTimer !== null && (clearTimeout(this.hideTimer), this.hideTimer = null), this.showTimer === null && (this.showTimer = window.setTimeout(() => {
      this.showTimer = null, this.show();
    }, this.showDelay));
  }
  scheduleHide() {
    this.showTimer !== null && (clearTimeout(this.showTimer), this.showTimer = null), this.hideTimer === null && (this.hideTimer = window.setTimeout(() => {
      this.hideTimer = null, this.hide();
    }, this.hideDelay));
  }
  show() {
    var e;
    (e = this.onBeforeShow) == null || e.call(this), this.visible = !0, this.element.classList.add(this.visibleClass), this.positionCleanup && (this.positionCleanup(), this.positionCleanup = null), this.followCursor ? this.positionAtCursor() : this.positionCleanup = _e(this.trigger, this.element, () => this.computeAt(this.trigger));
  }
  /** Position the tooltip relative to a reference (the trigger element or a pointer virtual element). */
  computeAt(e) {
    ke(e, this.element, {
      placement: this.placement,
      strategy: "fixed",
      middleware: [
        ye(this.offsetDistance),
        rt(),
        we({ padding: 8 })
      ]
    }).then(({ x: t, y: s }) => {
      Object.assign(this.element.style, {
        left: `${t}px`,
        top: `${s}px`
      });
    });
  }
  /** Position the tooltip relative to the last-known pointer location (follow-cursor mode). */
  positionAtCursor() {
    const e = this.cursorX, t = this.cursorY, s = {
      getBoundingClientRect: () => ({
        width: 0,
        height: 0,
        x: e,
        y: t,
        top: t,
        left: e,
        right: e,
        bottom: t
      })
    };
    this.computeAt(s);
  }
  hide() {
    this.visible = !1, this.element.classList.remove(this.visibleClass), this.positionCleanup && (this.positionCleanup(), this.positionCleanup = null);
  }
  /** Hide synchronously (skip the hideDelay). Used by parent tooltips when a child tooltip is about to show. */
  hideImmediate() {
    this.showTimer !== null && (clearTimeout(this.showTimer), this.showTimer = null), this.hideTimer !== null && (clearTimeout(this.hideTimer), this.hideTimer = null), this.hide();
  }
  destroy() {
    this.showTimer !== null && clearTimeout(this.showTimer), this.hideTimer !== null && clearTimeout(this.hideTimer), this.showTimer = null, this.hideTimer = null, this.positionCleanup && (this.positionCleanup(), this.positionCleanup = null), this.trigger.removeEventListener("mouseenter", this.handleMouseEnter), this.trigger.removeEventListener("mouseleave", this.handleMouseLeave), this.handleMouseMove && this.trigger.removeEventListener("mousemove", this.handleMouseMove), this.element.remove();
  }
}
function ys(o) {
  let e = o;
  for (; e && !(e === document.body || e === document.documentElement); ) {
    if (e instanceof Element) {
      const s = getComputedStyle(e);
      if (s.transform !== "none" || s.perspective !== "none" || s.filter !== "none") return e;
      const i = s.backdropFilter;
      if (i && i !== "none" || s.willChange && /\b(transform|filter|perspective)\b/.test(s.willChange)) return e;
    }
    const t = e.parentNode;
    e = t instanceof ShadowRoot ? t.host : t;
  }
  return window;
}
function ws(o, e, t) {
  let s = o;
  for (; s && !(s === document.body || s === document.documentElement); ) {
    if (s instanceof Element) {
      const r = s.getBoundingClientRect();
      if (Math.abs(r.x - e) < 2 && Math.abs(r.y - t) < 2) return s;
    }
    const i = s.parentNode;
    s = i instanceof ShadowRoot ? i.host : i;
  }
  return null;
}
function ks(o) {
  const e = getComputedStyle(o), t = [];
  e.transform !== "none" && t.push(`transform: ${e.transform}`), e.perspective !== "none" && t.push(`perspective: ${e.perspective}`), e.filter !== "none" && t.push(`filter: ${e.filter}`);
  const s = e.backdropFilter;
  return s && s !== "none" && t.push(`backdrop-filter: ${s}`), e.willChange && /\b(transform|filter|perspective)\b/.test(e.willChange) && t.push(`will-change: ${e.willChange}`), e.contain && /\b(paint|layout|strict|content)\b/.test(e.contain) && t.push(`contain: ${e.contain}`), e.containerType && e.containerType !== "normal" && t.push(`container-type: ${e.containerType}`), t.join("; ");
}
class xs {
  constructor(e, t = {}) {
    d(this, "element");
    d(this, "instanceId");
    d(this, "options");
    d(this, "isOpen", !1);
    d(this, "selectedValues", /* @__PURE__ */ new Set());
    d(this, "selectedOptions", /* @__PURE__ */ new Map());
    d(this, "allOptions", []);
    d(this, "filteredOptions", []);
    d(this, "hiddenInputs", []);
    d(this, "focusedIndex", -1);
    d(this, "matchingIndices", /* @__PURE__ */ new Set());
    d(this, "searchTerm", "");
    d(this, "isLoading", !1);
    d(this, "searchDebounceTimer");
    d(this, "searchAbortController");
    d(this, "showSelectedPopover", !1);
    d(this, "selectedPopoverPlacement", null);
    d(this, "dropdownPlacement", null);
    d(this, "isRTL", !1);
    d(this, "effectiveBadgesPosition", "bottom");
    d(this, "justClosedViaClick", !1);
    d(this, "positioningDriftWarned", !1);
    // Floating UI cleanup functions
    d(this, "dropdownCleanup", null);
    d(this, "hintCleanup", null);
    d(this, "selectedPopoverCleanup", null);
    // All hover tooltips (badge text, badge-remove buttons, action buttons), keyed by id.
    d(this, "tooltips", /* @__PURE__ */ new Map());
    // Virtual scroll instance
    d(this, "virtualScroll", null);
    d(this, "optionsContainer", null);
    d(this, "selectedPopoverVirtualScroll", null);
    d(this, "selectedPopoverContainer", null);
    // DOM elements
    d(this, "input");
    d(this, "dropdown");
    d(this, "dropdownInner");
    d(this, "badgesContainer");
    d(this, "counter");
    d(this, "hint");
    d(this, "selectedPopover");
    // Document-level event handlers (stored for cleanup)
    d(this, "documentKeydownHandler", null);
    d(this, "documentClickHandler", null);
    this.element = e, this.instanceId = `MS-${Math.random().toString(36).slice(2, 11)}`, this.options = {
      // String options
      searchHint: e.dataset.searchHint || "",
      searchPlaceholder: e.dataset.searchPlaceholder || "Search...",
      selectPlaceholder: e.dataset.selectPlaceholder || "Pick an option...",
      noDataPlaceholder: e.dataset.noDataPlaceholder || void 0,
      dropdownMinWidth: e.dataset.dropdownMinWidth || void 0,
      dropdownMaxWidth: e.dataset.dropdownMaxWidth || void 0,
      badgesDisplayMode: e.dataset.badgesDisplayMode || "badges",
      badgesPosition: e.dataset.badgesPosition || "bottom",
      badgesThresholdMode: e.dataset.badgesThresholdMode || "count",
      maxHeight: e.dataset.maxHeight || "20rem",
      emptyMessage: e.dataset.emptyMessage || "No results found",
      loadingMessage: e.dataset.loadingMessage || "Loading...",
      searchInputMode: e.dataset.searchInputMode || "normal",
      searchMode: e.dataset.searchMode || "filter",
      // Number options
      badgesThreshold: e.dataset.badgesThreshold ? parseInt(e.dataset.badgesThreshold) : void 0,
      minSearchLength: parseInt(e.dataset.minSearchLength || "0") || 0,
      searchDebounce: parseInt(e.dataset.searchDebounce || "0") || 0,
      // Boolean options (internal names with 'is' prefix)
      isMultipleEnabled: e.dataset.multiple !== "false",
      isGroupsAllowed: e.dataset.allowGroups !== "false",
      isCheckboxesShown: e.dataset.showCheckboxes !== "false",
      isActionsSticky: e.dataset.stickyActions !== "false",
      isCloseOnSelect: e.dataset.closeOnSelect === "true",
      isPlacementLocked: e.dataset.lockPlacement !== "false",
      isSearchEnabled: e.dataset.enableSearch !== "false",
      isAddNewAllowed: e.dataset.allowAddNew === "true",
      isCounterShown: e.dataset.showCounter === "true",
      isKeepOptionsOnSearch: e.dataset.keepOptionsOnSearch !== "false",
      shouldKeepSearchOnClose: e.dataset.keepSearchOnClose !== "false",
      // Data and callbacks
      options: [],
      container: void 0,
      // Override with provided options
      ...t
    }, this.init();
  }
  // ========================================================================
  // DATA EXTRACTION METHODS (following svelte-treeview pattern)
  // ========================================================================
  /**
   * Generic field extractor with the precedence:
   *   tuple short-circuit -> member property -> callback -> fallback
   *
   * Tuple handling:
   *   - `tupleIndex` (0 | 1): for `[key, value]` items, return that slot.
   *   - `tupleSkip: true`: for any tuple, skip directly to fallback (used for icon/subtitle/group/disabled —
   *     fields that don't make sense on a 2-element array).
   *   - neither: tuples flow through the member/callback/fallback chain as if they were objects.
   *
   * `transform` is applied to tuple-slot and member-property reads (not to callback returns or the fallback),
   * so e.g. you can pass `String` to coerce numeric members to strings while letting a typed callback return its
   * own type unchanged.
   */
  extractField(e, t) {
    if (Array.isArray(e) && e.length === 2) {
      if (t.tupleSkip)
        return typeof t.fallback == "function" ? t.fallback() : t.fallback;
      if (t.tupleIndex !== void 0) {
        const i = e[t.tupleIndex];
        return t.transform ? t.transform(i) : i;
      }
    }
    if (t.member && e[t.member] !== void 0) {
      const i = e[t.member];
      return t.transform ? t.transform(i) : i;
    }
    return t.callback ? t.callback(e) : typeof t.fallback == "function" ? t.fallback() : t.fallback;
  }
  getItemValue(e) {
    return this.extractField(e, {
      tupleIndex: 0,
      member: this.options.valueMember,
      callback: this.options.getValueCallback,
      fallback: "[N/A]"
    });
  }
  getItemDisplayValue(e) {
    return this.extractField(e, {
      tupleIndex: 1,
      member: this.options.displayValueMember,
      callback: this.options.getDisplayValueCallback,
      transform: String,
      fallback: "[N/A]"
    });
  }
  /**
   * Badge display falls back to the regular display value rather than '[N/A]', so consumers can override badge
   * text independently. Doesn't fit the extractField shape (no tuple/member layer of its own).
   */
  getItemBadgeDisplayValue(e) {
    return this.options.getBadgeDisplayCallback ? this.options.getBadgeDisplayCallback(e) : this.getItemDisplayValue(e);
  }
  getItemSearchValue(e) {
    return this.extractField(e, {
      member: this.options.searchValueMember,
      callback: this.options.getSearchValueCallback,
      transform: String,
      fallback: () => this.getItemDisplayValue(e)
    });
  }
  getItemIcon(e) {
    return this.extractField(e, {
      tupleSkip: !0,
      member: this.options.iconMember,
      callback: this.options.getIconCallback,
      transform: String,
      fallback: void 0
    });
  }
  getItemSubtitle(e) {
    return this.extractField(e, {
      tupleSkip: !0,
      member: this.options.subtitleMember,
      callback: this.options.getSubtitleCallback,
      transform: String,
      fallback: void 0
    });
  }
  getItemGroup(e) {
    return this.extractField(e, {
      tupleSkip: !0,
      member: this.options.groupMember,
      callback: this.options.getGroupCallback,
      transform: String,
      fallback: void 0
    });
  }
  getItemDisabled(e) {
    return this.extractField(e, {
      tupleSkip: !0,
      member: this.options.disabledMember,
      callback: this.options.getDisabledCallback,
      transform: Boolean,
      fallback: !1
    });
  }
  init() {
    this.parseOptions(), this.buildHTML(), this.attachEvents(), this.parseInitialSelection(), oe.debug(`Initialized [${this.instanceId}] with options:`, {
      placeholder: this.options.searchPlaceholder,
      totalOptions: this.allOptions.length,
      isCloseOnSelect: this.options.isCloseOnSelect,
      dataAttribute: this.element.dataset.closeOnSelect
    });
  }
  parseOptions() {
    const e = this.element.dataset.options;
    if (e)
      try {
        this.allOptions = JSON.parse(e);
      } catch (t) {
        x.error(`[${this.instanceId}] Failed to parse data-options:`, t), this.allOptions = [];
      }
    else this.options.options && (this.allOptions = this.options.options);
    this.filteredOptions = [...this.allOptions];
  }
  buildHTML() {
    const e = this.options.container || document.body, t = this.element.getRootNode(), s = t instanceof ShadowRoot ? t.host : this.element, i = s.getAttribute("dir") === "rtl", r = s.closest('[dir="rtl"]') !== null;
    this.isRTL = i || r, oe.debug(`[${this.instanceId}] RTL Debug:`, {
      isShadowRoot: t instanceof ShadowRoot,
      hostElement: s,
      elementDir: s.getAttribute("dir"),
      hasElementDir: i,
      hasAncestorDir: r,
      isRTL: this.isRTL
    }), this.effectiveBadgesPosition = this.options.badgesPosition || "bottom", this.isRTL && (this.effectiveBadgesPosition === "left" ? this.effectiveBadgesPosition = "right" : this.effectiveBadgesPosition === "right" && (this.effectiveBadgesPosition = "left")), this.element.classList.add("ms"), this.isRTL && (this.element.classList.add("ms--rtl"), oe.debug(`[${this.instanceId}] Added ms--rtl class to element`)), (!this.options.isCheckboxesShown || !this.options.isMultipleEnabled) && this.element.classList.add("ms--no-checkboxes");
    const n = document.createElement("div");
    n.className = "ms__input-wrapper", this.input = document.createElement("input"), this.input.type = "text", this.input.className = "ms__input", this.input.placeholder = this.getPlaceholderText(), this.input.autocomplete = "off", this.options.searchInputMode === "readonly" ? this.input.readOnly = !0 : this.options.searchInputMode === "hidden" && (this.input.style.display = "none");
    const a = document.createElement("span");
    a.className = "ms__toggle", a.innerHTML = "▼", this.counter = document.createElement("span"), this.counter.className = "ms__counter", this.counter.style.display = "none", n.appendChild(this.input), n.appendChild(this.counter), n.appendChild(a), this.badgesContainer = document.createElement("div"), this.badgesContainer.className = "ms__badges";
    const l = document.createElement("div");
    l.className = "ms__wrapper", (this.effectiveBadgesPosition === "left" || this.effectiveBadgesPosition === "right") && l.classList.add("ms__wrapper--inline"), l.appendChild(n), l.appendChild(this.badgesContainer), this.element.appendChild(l), this.dropdown = document.createElement("div"), this.dropdown.className = "ms__dropdown", this.dropdownInner = document.createElement("div"), this.dropdownInner.className = "ms__dropdown-inner", this.dropdown.appendChild(this.dropdownInner), e.appendChild(this.dropdown), this.options.searchHint && (this.hint = document.createElement("div"), this.hint.className = "ms__hint", this.hint.textContent = this.options.searchHint, e.appendChild(this.hint)), this.selectedPopover = document.createElement("div"), this.selectedPopover.className = "ms__selected-popover", e.appendChild(this.selectedPopover), this.renderDropdown();
  }
  /**
   * Check if virtual scroll should be used
   */
  shouldUseVirtualScroll() {
    if (!this.options.isVirtualScrollEnabled || this.options.isGroupsAllowed && this.hasGroups()) return !1;
    const e = this.options.virtualScrollThreshold ?? 100;
    return this.filteredOptions.length >= e;
  }
  /**
   * Check if any options have groups
   */
  hasGroups() {
    return this.filteredOptions.some((e) => {
      const t = this.getItemGroup(e);
      return t && t.trim() !== "";
    });
  }
  renderDropdown() {
    if (this.destroyAllActionButtonTooltips(), this.shouldUseVirtualScroll()) {
      this.dropdown.classList.add("ms__dropdown--virtual"), this.renderDropdownVirtual();
      return;
    }
    this.dropdown.classList.remove("ms__dropdown--virtual"), this.virtualScroll && (this.virtualScroll.destroy(), this.virtualScroll = null, this.optionsContainer = null);
    let e = "";
    if (this.isLoading) {
      e += '<div class="ms__loader">', e += '<div class="pa-loader pa-loader--sm"></div>', e += `<div class="ms__loading-text">${this.options.loadingMessage}</div>`, e += "</div>", this.dropdownInner.innerHTML = e;
      return;
    }
    const t = this.renderActionsHTML(), s = this.options.actionsPosition === "bottom";
    if (s || (e += t), e += '<div class="ms__options">', this.filteredOptions.length === 0)
      e += `<div class="ms__empty">${this.options.emptyMessage}</div>`;
    else if (this.options.isGroupsAllowed) {
      const i = this.groupOptions(this.filteredOptions), r = /* @__PURE__ */ new Map();
      this.filteredOptions.forEach((n, a) => r.set(n, a)), Object.keys(i).forEach((n) => {
        if (e += '<div class="ms__group">', n !== "__ungrouped__")
          if (this.options.renderGroupLabelContentCallback) {
            const a = this.options.renderGroupLabelContentCallback(n);
            if (a instanceof HTMLElement) {
              const l = document.createElement("div");
              l.className = "ms__group-label", l.appendChild(a), e += l.outerHTML;
            } else
              e += `<div class="ms__group-label">${a}</div>`;
          } else
            e += `<div class="ms__group-label">${n}</div>`;
        i[n].forEach((a) => {
          e += this.renderOption(a, r.get(a) ?? -1);
        }), e += "</div>";
      });
    } else
      this.filteredOptions.forEach((i, r) => {
        e += this.renderOption(i, r);
      });
    e += "</div>", s && (e += t), this.dropdownInner.innerHTML = e, this.attachActionButtonTooltips(), this.attachOptionTooltips();
  }
  /**
   * Render dropdown with virtual scrolling
   */
  renderDropdownVirtual() {
    if (this.destroyAllActionButtonTooltips(), !this.virtualScroll) {
      let s = "";
      const i = this.renderActionsHTML(), r = this.options.actionsPosition === "bottom";
      r || (s += i);
      const n = this.options.maxHeight || "20rem", a = this.options.optionHeight ?? 50;
      s += `<div class="ms__options ms__options--virtual" style="height: ${n}; max-height: ${n}; overflow-y: auto; position: relative; --ms-option-height: ${a}px;"></div>`, r && (s += i), this.dropdownInner.innerHTML = s, this.optionsContainer = this.dropdownInner.querySelector(".ms__options");
    }
    if (this.filteredOptions.length === 0) {
      this.virtualScroll && (this.virtualScroll.destroy(), this.virtualScroll = null), this.optionsContainer.innerHTML = `<div class="ms__empty">${this.options.emptyMessage}</div>`;
      return;
    }
    const e = this.options.optionHeight ?? 50, t = this.options.virtualScrollBuffer ?? 10;
    requestAnimationFrame(() => {
      this.optionsContainer && (this.virtualScroll ? this.virtualScroll.setItems(this.filteredOptions) : this.virtualScroll = new We({
        container: this.optionsContainer,
        itemHeight: e,
        items: this.filteredOptions,
        renderItem: (s, i) => this.renderOption(s, i),
        bufferSize: t,
        onVisibleRangeChange: () => {
          this.attachOptionTooltips();
        }
      }), this.attachActionButtonTooltips());
    });
  }
  /**
   * Render the Select All / Clear All / custom action buttons row.
   * Returns the empty string if multiple-select is off or no buttons are configured.
   */
  /**
   * Default enabled/disabled state for the built-in actions, applied only when the consumer hasn't
   * set an explicit `isDisabled` / `getIsDisabledCallback`:
   * - `select-all` is disabled when it would add nothing (every selectable, non-disabled filtered
   *   option is already selected — this also covers an empty list).
   * - `clear-all` is disabled when nothing is selected.
   */
  getBuiltInActionDisabled(e) {
    return e === "select-all" ? !this.filteredOptions.some((t) => !this.getItemDisabled(t) && !this.selectedValues.has(String(this.getItemValue(t)))) : e === "clear-all" ? this.selectedValues.size === 0 : !1;
  }
  renderActionsHTML() {
    const e = this.options.actionButtons;
    if (!this.options.isMultipleEnabled || !e || e.length === 0) return "";
    const t = this.options.actionsPosition === "bottom" ? "bottom" : "top", s = this.options.actionsAlign ?? "stretch", i = ` ms__actions--${t}`, r = this.options.isActionsSticky ? " ms__actions--sticky" : "", n = this.options.actionsLayout === "wrap" ? " ms__actions--wrap" : "", a = ` ms__actions--align-${s}`, l = /* @__PURE__ */ new Map();
    if (e.forEach((c, p) => {
      if (!(c.getIsVisibleCallback ? c.getIsVisibleCallback(this) : c.isVisible ?? !0)) return;
      let m;
      c.getIsDisabledCallback ? m = c.getIsDisabledCallback(this) : c.isDisabled !== void 0 ? m = c.isDisabled : m = this.getBuiltInActionDisabled(c.action);
      const b = m ? " disabled" : "", f = c.getTextCallback ? c.getTextCallback(this) : c.text;
      let g = "";
      if (c.getClassCallback) {
        const w = c.getClassCallback(this);
        g = Array.isArray(w) ? ` ${w.join(" ")}` : w ? ` ${w}` : "";
      } else c.cssClass && (g = ` ${c.cssClass}`);
      const v = Math.max(1, Math.floor(c.row ?? 1)), _ = `<button type="button"${b} class="ms__action-btn${g}" data-action="${c.action}" data-button-index="${p}">${f}</button>`;
      l.has(v) || l.set(v, []), l.get(v).push(_);
    }), l.size === 0) return "";
    const h = Array.from(l.keys()).sort((c, p) => c - p).map((c) => `<div class="ms__actions-row" data-row="${c}">${l.get(c).join("")}</div>`).join("");
    return `<div class="ms__actions${i}${r}${n}${a}">${h}</div>`;
  }
  renderOption(e, t) {
    const s = this.getItemValue(e), i = this.getItemDisplayValue(e), r = this.getItemIcon(e), n = this.getItemSubtitle(e), a = this.getItemDisabled(e), l = this.selectedValues.has(String(s)), h = t === this.focusedIndex, c = this.matchingIndices.has(t), p = ["ms__option"];
    l && p.push("ms__option--selected"), h && p.push("ms__option--focused"), c && p.push("ms__option--matched"), a && p.push("ms__option--disabled");
    const u = this.options.checkboxAlign && this.options.checkboxAlign !== "center" ? ` data-checkbox-align="${this.options.checkboxAlign}"` : "";
    let m = `<div class="${p.join(" ")}" data-value="${s}" data-index="${t}"${u}>`;
    if (this.options.isCheckboxesShown && this.options.isMultipleEnabled && (m += `<input type="checkbox" class="ms__checkbox" ${l ? "checked" : ""} ${a ? "disabled" : ""}>`), m += '<div class="ms__option-content">', this.options.renderOptionContentCallback) {
      const b = {
        index: t,
        isSelected: l,
        isFocused: h,
        isMatched: c,
        isDisabled: a
      }, f = this.options.renderOptionContentCallback(e, b);
      typeof f == "string" ? m += f : m += f.outerHTML;
    } else
      r && (m += `<span class="ms__option-icon">${r}</span>`), m += '<div class="ms__option-text">', m += `<div class="ms__option-title">${this.highlightMatch(i, this.searchTerm)}</div>`, n && (m += `<div class="ms__option-subtitle">${n}</div>`), m += "</div>";
    return m += "</div>", m += "</div>", m;
  }
  highlightMatch(e, t) {
    if (!t) return e;
    const s = new RegExp(`(${t.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")})`, "gi");
    return e.replace(s, "<mark>$1</mark>");
  }
  groupOptions(e) {
    const t = {};
    return e.forEach((s) => {
      const i = this.getItemGroup(s) || "__ungrouped__";
      t[i] || (t[i] = []), t[i].push(s);
    }), t;
  }
  /** Whether the input currently functions as a usable search field (drives placeholder wording). */
  get isSearchUsable() {
    return !!this.options.isSearchEnabled && this.options.searchInputMode !== "readonly" && this.options.searchInputMode !== "hidden";
  }
  /**
   * Resolve the closed-state input placeholder for the current data/search state.
   * Priority: explicit no-data placeholder (when the list is empty) → "pick" prompt when
   * search is unusable → the search placeholder.
   */
  getPlaceholderText() {
    return this.options.noDataPlaceholder && this.allOptions.length === 0 ? this.options.noDataPlaceholder : this.isSearchUsable ? this.options.searchPlaceholder : this.options.selectPlaceholder || this.options.searchPlaceholder;
  }
  renderBadges() {
    this.destroyAllBadgeTooltips();
    const e = Array.from(this.selectedOptions.values()), t = this.selectedValues.size;
    if (!this.options.isMultipleEnabled) {
      this.badgesContainer.innerHTML = "", this.counter.style.display = "none";
      let r;
      e[0] && (this.options.renderSelectedContentCallback ? r = this.options.renderSelectedContentCallback(e[0]) : r = this.getItemDisplayValue(e[0])), !this.isOpen && t > 0 && e.length > 0 ? this.input.value = r : this.isOpen || (this.input.value = "");
      return;
    }
    let s = this.options.badgesDisplayMode;
    if (this.options.badgesThreshold !== null && t > this.options.badgesThreshold && s !== "none" && (s = this.options.badgesThresholdMode || "count"), !this.isOpen)
      if (t > 0 && s === "count") {
        const r = this.options.getCounterCallback ? this.options.getCounterCallback(t) : `${t} selected`;
        this.input.placeholder = r;
      } else
        this.input.placeholder = this.getPlaceholderText();
    if (this.options.isCounterShown && t > 0 ? (this.counter.textContent = `[${t}]`, this.counter.style.display = "") : this.counter.style.display = "none", s === "none") {
      this.badgesContainer.innerHTML = "";
      return;
    }
    if (s === "badges")
      this.badgesContainer.className = `ms__badges ms__badges--${this.effectiveBadgesPosition}`, this.badgesContainer.innerHTML = e.map((r) => this.renderBadgeHTML(r, { displayMode: "badges", isInPopover: !1 })).join("");
    else if (s === "partial") {
      this.badgesContainer.className = `ms__badges ms__badges--${this.effectiveBadgesPosition}`;
      const r = this.options.badgesMaxVisible || 3, n = e.slice(0, r), a = t - r, l = n.map((c) => this.renderBadgeHTML(c, { displayMode: "partial", isInPopover: !1 })).join("");
      let h = "";
      a > 0 && (h = `
                    <div class="ms__badge ms__badge--counter ms__badge--more" data-action="show-selected">
                        <span class="ms__badge-text">${this.options.getCounterCallback ? this.options.getCounterCallback(t, a) : `+${a} more`}</span>
                        <button type="button" class="ms__badge-remove" data-action="remove-hidden" aria-label="Remove ${a} hidden items"></button>
                    </div>
                `), this.badgesContainer.innerHTML = l + h;
    } else if (s === "compact")
      if (this.badgesContainer.className = `ms__badges ms__badges--${this.effectiveBadgesPosition}`, t > 0) {
        const r = e[0], n = this.getItemBadgeDisplayValue(r), a = t - 1;
        let l = n;
        if (a > 0) {
          const h = this.options.getCounterCallback ? this.options.getCounterCallback(t, a) : `+${a} more`;
          l = `${n} (${h})`;
        }
        this.badgesContainer.innerHTML = `
                    <div class="ms__badge" data-action="show-selected">
                        <span class="ms__badge-text">${l}</span>
                        <button type="button" class="ms__badge-remove" data-action="clear-count" aria-label="Clear all selections"></button>
                    </div>
                `;
      } else
        this.badgesContainer.innerHTML = "";
    else if (this.badgesContainer.className = `ms__badges ms__badges--${this.effectiveBadgesPosition}`, t > 0) {
      const r = this.options.getCounterCallback ? this.options.getCounterCallback(t) : `${t} selected`;
      this.badgesContainer.innerHTML = `
                    <div class="ms__badge ms__badge--counter" data-action="show-selected">
                        <span class="ms__badge-text">${r}</span>
                        <button type="button" class="ms__badge-remove" data-action="clear-count" aria-label="Clear all selections"></button>
                    </div>
                `;
    } else
      this.badgesContainer.innerHTML = "";
    this.attachBadgeTooltips();
  }
  attachEvents() {
    this.input.addEventListener("mousedown", (e) => {
      e.stopPropagation(), this.isOpen ? (this.justClosedViaClick = !0, this.close(), setTimeout(() => {
        this.justClosedViaClick = !1;
      }, 0)) : this.open();
    }), this.input.addEventListener("focus", () => {
      !this.isOpen && !this.justClosedViaClick && this.open();
    }), this.input.addEventListener("input", (e) => {
      const t = e.target.value;
      this.options.isSearchEnabled && !this.isOpen && this.open(), this.handleSearch(t);
    }), this.input.addEventListener("keydown", (e) => this.handleKeydown(e)), this.documentClickHandler = (e) => this.handleClickOutside(e), setTimeout(() => {
      document.addEventListener("click", this.documentClickHandler);
    }, 0), this.documentKeydownHandler = (e) => {
      e.key === "Escape" && this.showSelectedPopover && (e.preventDefault(), this.hideSelectedPopover());
    }, document.addEventListener("keydown", this.documentKeydownHandler), this.dropdown.addEventListener("click", (e) => this.handleDropdownClick(e)), this.dropdownInner.addEventListener("wheel", (e) => {
      if (this.virtualScroll)
        return;
      const t = e.currentTarget, s = t.scrollTop === 0, i = t.scrollTop + t.clientHeight >= t.scrollHeight;
      (e.deltaY < 0 && s || e.deltaY > 0 && i) && e.preventDefault(), e.stopPropagation();
    }, { passive: !1 }), this.badgesContainer.addEventListener("mousedown", (e) => {
      e.target.closest('[data-action="show-selected"]') && !this.showSelectedPopover && e.stopPropagation();
    }), this.badgesContainer.addEventListener("click", (e) => this.handleBadgeClick(e)), this.counter.addEventListener("mousedown", (e) => {
      this.showSelectedPopover || e.stopPropagation();
    }), this.counter.addEventListener("click", (e) => {
      e.stopPropagation(), this.toggleSelectedPopover();
    }), this.selectedPopover.addEventListener("click", (e) => this.handleSelectedPopoverClick(e));
  }
  async handleSearch(e) {
    if (this.searchTerm = e, !this.options.isSearchEnabled)
      return;
    let t = e;
    if (this.options.beforeSearchCallback) {
      const s = this.options.beforeSearchCallback(e);
      if (s === null) {
        x.debug(`[${this.instanceId}] beforeSearchCallback blocked search for term:`, e), this.abortInFlightSearch(), this.filteredOptions = [...this.allOptions], this.matchingIndices.clear(), this.renderDropdown();
        return;
      }
      t = s, t !== e && x.debug(`[${this.instanceId}] beforeSearchCallback transformed: "${e}" -> "${t}"`);
    }
    if (this.options.searchCallback) {
      if (t.length < this.options.minSearchLength) {
        this.abortInFlightSearch(), this.isLoading = !1, this.options.isKeepOptionsOnSearch ? (this.filteredOptions = [...this.allOptions], x.debug(`[${this.instanceId}] Search term below minimum, showing ${this.allOptions.length} initial options`)) : this.filteredOptions = [], this.matchingIndices.clear(), this.renderDropdown();
        return;
      }
      this.searchDebounceTimer && (clearTimeout(this.searchDebounceTimer), this.searchDebounceTimer = void 0);
      const s = this.options.searchDebounce || 0;
      s > 0 ? this.searchDebounceTimer = setTimeout(() => {
        this.searchDebounceTimer = void 0, this.searchTerm === e && this.performAsyncSearch(e, t);
      }, s) : await this.performAsyncSearch(e, t);
    } else {
      if (!t)
        this.filteredOptions = [...this.allOptions], this.matchingIndices.clear(), this.focusedIndex = this.filteredOptions.length > 0 ? 0 : -1;
      else {
        const s = this.options.searchMode || "filter", i = t.toLowerCase();
        if (s === "filter")
          this.filteredOptions = this.allOptions.filter((r) => this.getItemSearchValue(r).toLowerCase().includes(i)), this.matchingIndices.clear(), this.focusedIndex = this.filteredOptions.length > 0 ? 0 : -1, x.debug(`[${this.instanceId}] Filter mode: ${this.filteredOptions.length} matches for "${t}"`);
        else {
          this.filteredOptions = [...this.allOptions], this.matchingIndices.clear();
          let r = -1;
          this.allOptions.forEach((n, a) => {
            this.getItemSearchValue(n).toLowerCase().includes(i) && (this.matchingIndices.add(a), r === -1 && (r = a));
          }), r >= 0 ? (this.focusedIndex = r, x.debug(`[${this.instanceId}] Navigate mode: ${this.matchingIndices.size} matches, jumped to index ${r}`)) : x.debug(`[${this.instanceId}] Navigate mode: No matches found, keeping previous focus`);
        }
      }
      this.renderDropdown(), this.options.searchMode === "navigate" && this.focusedIndex >= 0 && this.scrollToFocused();
    }
  }
  /** Abort the search request currently in flight, if any. The aborted request's results
   *  are then ignored (and the consumer's `searchCallback` can short-circuit its fetch via
   *  the `AbortSignal` it was handed). */
  abortInFlightSearch() {
    this.searchAbortController && (this.searchAbortController.abort(), this.searchAbortController = void 0);
  }
  /**
   * Invoke the async `searchCallback` and apply its results. Split out of `handleSearch`
   * so it can be called immediately or after the debounce timer.
   *
   * Any request still in flight is aborted before a new one starts, so a slow earlier
   * request can't overwrite a newer one — and consumers that wire the passed `AbortSignal`
   * into their fetch get the request actually cancelled, not just ignored. The
   * `aborted` / `searchTerm === value` guards drop superseded or out-of-order responses.
   */
  async performAsyncSearch(e, t) {
    this.abortInFlightSearch();
    const s = new AbortController();
    this.searchAbortController = s, this.isLoading = !0, this.renderDropdown(), x.debug(`[${this.instanceId}] Loading data for search term:`, t);
    try {
      const i = await this.options.searchCallback(t, s.signal);
      if (s.signal.aborted || this.searchTerm !== e) return;
      const r = i || [];
      this.filteredOptions = [...r], this.isLoading = !1, this.matchingIndices.clear(), this.focusedIndex = this.options.isSearchEnabled && this.filteredOptions.length > 0 ? 0 : -1, this.renderDropdown(), x.debug(`[${this.instanceId}] Loaded ${r.length} results`);
    } catch (i) {
      if (s.signal.aborted) return;
      x.error(`[${this.instanceId}] Error loading data:`, i), this.isLoading = !1, this.options.isKeepOptionsOnSearch ? this.filteredOptions = [...this.allOptions] : this.filteredOptions = [], this.matchingIndices.clear(), this.renderDropdown();
    } finally {
      this.searchAbortController === s && (this.searchAbortController = void 0);
    }
  }
  handleKeydown(e) {
    if (!this.isOpen) {
      (e.key === "Enter" || e.key === "ArrowDown") && (e.preventDefault(), this.open());
      return;
    }
    if (!this.options.isSearchEnabled) {
      const t = e.key.length === 1 || e.key === "Backspace" || e.key === "Delete", s = ["ArrowUp", "ArrowDown", "PageUp", "PageDown", "Home", "End", "Enter", "Escape", "Tab"].includes(e.key);
      if (t && !s) {
        e.preventDefault();
        return;
      }
    }
    switch (e.key) {
      case "ArrowDown":
        e.preventDefault(), e.ctrlKey || e.metaKey ? this.focusNextMatch() : this.focusNext();
        break;
      case "ArrowUp":
        e.preventDefault(), e.ctrlKey || e.metaKey ? this.focusPreviousMatch() : this.focusPrevious();
        break;
      case "Enter":
        e.preventDefault(), this.focusedIndex >= 0 ? this.toggleOption(this.filteredOptions[this.focusedIndex]) : this.options.isAddNewAllowed && this.options.addNewCallback && this.input.value.trim() && this.handleAddNew(this.input.value.trim());
        break;
      case "Escape":
        e.preventDefault(), this.showSelectedPopover ? this.hideSelectedPopover() : this.input.value ? (this.input.value = "", this.searchTerm = "", this.filteredOptions = [...this.allOptions], this.focusedIndex = -1, this.renderDropdown()) : this.close();
        break;
      case "Tab":
        this.close();
        break;
      case "PageUp":
        e.preventDefault(), this.focusPageUp();
        break;
      case "PageDown":
        e.preventDefault(), this.focusPageDown();
        break;
      case "Home":
        e.preventDefault(), this.focusFirst();
        break;
      case "End":
        e.preventDefault(), this.focusLast();
        break;
    }
  }
  handleDropdownClick(e) {
    var i;
    S.debug(`[${this.instanceId}] Dropdown clicked`, { target: e.target.className }), e.stopPropagation();
    const t = e.target.closest("[data-action]");
    if (t) {
      e.preventDefault();
      const r = t.dataset.action;
      if (S.debug(`[${this.instanceId}] Action button clicked:`, r), r === "select-all")
        this.selectAll();
      else if (r === "clear-all")
        this.clearAll();
      else if (r === "custom") {
        const n = parseInt(t.dataset.buttonIndex || "-1"), a = (i = this.options.actionButtons) == null ? void 0 : i[n];
        a != null && a.onClick && a.onClick(this);
      }
      return;
    }
    const s = e.target.closest(".ms__option");
    if (s && !s.classList.contains("ms__option--disabled")) {
      e.preventDefault();
      const r = s.dataset.value, n = this.filteredOptions.findIndex((a) => String(this.getItemValue(a)) === r);
      S.debug(`[${this.instanceId}] Option clicked:`, {
        value: r,
        optionIndex: n,
        closeOnSelect: this.options.isCloseOnSelect,
        placeholder: this.options.searchPlaceholder
      }), n >= 0 && (this.focusedIndex = n, this.toggleOption(this.filteredOptions[n]), this.isOpen && this.input.focus());
    }
  }
  handleBadgeClick(e) {
    if (e.target.closest('[data-action="clear-count"]')) {
      e.preventDefault(), e.stopPropagation(), S.debug(`[${this.instanceId}] Clear count button clicked`), this.clearAll();
      return;
    }
    if (e.target.closest('[data-action="show-selected"]')) {
      e.preventDefault(), e.stopPropagation(), this.toggleSelectedPopover();
      return;
    }
    const i = e.target.closest(".ms__badge-remove");
    if (i) {
      if (e.preventDefault(), e.stopPropagation(), i.dataset.action === "remove-hidden") {
        S.debug(`[${this.instanceId}] Remove hidden items button clicked`);
        const l = this.options.badgesMaxVisible || 3;
        Array.from(this.selectedOptions.values()).slice(l).forEach((p) => this.interactiveDeselect(p));
        return;
      }
      const n = i.dataset.value, a = this.selectedOptions.get(n);
      a && this.interactiveDeselect(a);
      return;
    }
    if (e.target.closest(".ms__badge--more") && !e.target.closest(".ms__badge-remove")) {
      e.preventDefault(), e.stopPropagation(), S.debug(`[${this.instanceId}] '+X more' badge clicked, showing popover`), this.toggleSelectedPopover();
      return;
    }
  }
  handleClickOutside(e) {
    var i;
    const t = e.composedPath();
    if (this.showSelectedPopover && !t.some(
      (n) => n instanceof Node && (this.selectedPopover.contains(n) || this.counter.contains(n) || n.closest && n.closest('[data-action="show-selected"]'))
    )) {
      P.debug(`[${this.instanceId}] Closing selected popover due to click outside`), this.hideSelectedPopover();
      return;
    }
    if (!this.isOpen) return;
    const s = t.some(
      (r) => r instanceof Node && (this.element.contains(r) || this.dropdown.contains(r) || this.hint && this.hint.contains(r))
    );
    S.debug(`[${this.instanceId}] handleClickOutside`, {
      target: e.target.className,
      targetTag: e.target.tagName,
      clickedInside: s,
      pathLength: t.length,
      firstInPath: (i = t[0]) == null ? void 0 : i.tagName,
      elementContains: t.some((r) => r instanceof Node && this.element.contains(r)),
      dropdownContains: t.some((r) => r instanceof Node && this.dropdown.contains(r)),
      isConnected: this.dropdown.isConnected
    }), s || (S.warn(`[${this.instanceId}] Closing dropdown due to click outside`), this.close());
  }
  /**
   * Move focus by computing a new index from (current, total).
   * Returning -1 from `compute` is a no-op (used for empty list / no match).
   */
  focusBy(e) {
    const t = this.filteredOptions.length;
    if (t === 0) return;
    const s = e(this.focusedIndex, t);
    s < 0 || (this.focusedIndex = s, this.renderDropdown(), this.scrollToFocused());
  }
  focusNext() {
    this.focusBy((e, t) => Math.min(t - 1, e + 1));
  }
  focusPrevious() {
    this.focusBy((e) => Math.max(0, e - 1));
  }
  focusFirst() {
    this.focusBy(() => 0);
  }
  focusLast() {
    this.focusBy((e, t) => t - 1);
  }
  focusPageUp() {
    this.focusBy((e) => Math.max(0, e - 10));
  }
  focusPageDown() {
    this.focusBy((e, t) => Math.min(t - 1, e + 10));
  }
  focusNextMatch() {
    if (this.matchingIndices.size === 0) return;
    const e = Array.from(this.matchingIndices).sort((i, r) => i - r), t = e.findIndex((i) => i === this.focusedIndex), s = (t + 1) % e.length;
    this.focusBy(() => e[s]), S.debug(`[${this.instanceId}] Jumped to next match: index ${this.focusedIndex} (${t + 1} of ${e.length})`);
  }
  focusPreviousMatch() {
    if (this.matchingIndices.size === 0) return;
    const e = Array.from(this.matchingIndices).sort((i, r) => i - r), t = e.findIndex((i) => i === this.focusedIndex), s = t <= 0 ? e.length - 1 : t - 1;
    this.focusBy(() => e[s]), S.debug(`[${this.instanceId}] Jumped to previous match: index ${this.focusedIndex} (${t + 1} of ${e.length})`);
  }
  scrollToFocused() {
    if (this.virtualScroll && this.focusedIndex >= 0)
      this.virtualScroll.scrollToIndex(this.focusedIndex);
    else {
      const e = this.dropdown.querySelector(".ms__option--focused");
      e && e.scrollIntoView({ block: "nearest", behavior: "smooth" });
    }
  }
  toggleOption(e) {
    if (this.getItemDisabled(e)) {
      S.debug(`[${this.instanceId}] toggleOption ignored — option is disabled`);
      return;
    }
    const t = this.getItemValue(e), s = String(t);
    S.debug(`[${this.instanceId}] toggleOption called`, { value: t, multiple: this.options.isMultipleEnabled }), (this.selectedValues.has(s) ? this.interactiveDeselect(e) : this.interactiveSelect(e)) && (this.options.isMultipleEnabled ? this.options.isCloseOnSelect && this.close() : this.close());
  }
  /**
   * The single funnel for an interactive (user-initiated) selection. Consults
   * `beforeSelectCallback` and only mutates state if allowed, so the veto can
   * never be bypassed by a new UI entry point. Programmatic `setSelected` and
   * the Select-All button deliberately do not route through here.
   * Returns true if the option was selected, false if the veto blocked it.
   */
  interactiveSelect(e) {
    return this.options.beforeSelectCallback && this.options.beforeSelectCallback(e, this.getSelected()) === !1 ? (S.debug(`[${this.instanceId}] Selection blocked by beforeSelectCallback`), !1) : (this.options.isMultipleEnabled || (this.selectedValues.clear(), this.selectedOptions.clear()), this.selectOption(e), !0);
  }
  /**
   * The single funnel for an interactive (user-initiated) deselection. Every
   * removal affordance — dropdown toggle, badge × button, selected-items
   * popover × button, and the "remove hidden" badge — routes through here so
   * the `beforeDeselectCallback` veto applies uniformly. Programmatic
   * `setSelected` and the Clear-All button deliberately bypass it.
   * Returns true if the option was deselected, false if the veto blocked it.
   */
  interactiveDeselect(e) {
    return this.options.beforeDeselectCallback && this.options.beforeDeselectCallback(e, this.getSelected()) === !1 ? (S.debug(`[${this.instanceId}] Deselection blocked by beforeDeselectCallback`), !1) : (this.deselectOption(e), !0);
  }
  async handleAddNew(e) {
    if (this.options.addNewCallback)
      try {
        x.debug(`[${this.instanceId}] Adding new option:`, e);
        const t = await this.options.addNewCallback(e);
        this.allOptions.push(t), this.filteredOptions.push(t), this.selectOption(t), this.input.value = "", this.renderDropdown(), this.renderBadges(), this.options.isCloseOnSelect && this.close();
      } catch (t) {
        x.error(`[${this.instanceId}] Error adding new option:`, t);
      }
  }
  selectOption(e) {
    const t = this.getItemValue(e), s = String(t);
    this.selectedValues.add(s), this.selectedOptions.set(s, e), this.commit({ added: [e] });
  }
  deselectOption(e) {
    const t = this.getItemValue(e), s = String(t);
    this.selectedValues.delete(s), this.selectedOptions.delete(s), this.commit({ removed: [e] });
  }
  selectAll() {
    const e = [];
    this.filteredOptions.forEach((t) => {
      if (this.getItemDisabled(t)) return;
      const s = String(this.getItemValue(t));
      this.selectedValues.has(s) || (this.selectedValues.add(s), this.selectedOptions.set(s, t), e.push(t));
    }), this.commit({ added: e });
  }
  clearAll() {
    const e = Array.from(this.selectedOptions.values());
    this.selectedValues.clear(), this.selectedOptions.clear(), this.commit({ removed: e });
  }
  /**
   * Re-render and fire callbacks after a selection state change.
   * `added` / `removed` drive per-item select/deselect callbacks.
   * `onChange` fires once if anything actually changed.
   */
  commit(e) {
    this.renderDropdown(), this.renderBadges(), this.updateHiddenInput();
    const t = e.added ?? [], s = e.removed ?? [];
    this.options.onSelect && t.forEach((i) => this.options.onSelect(i)), this.options.onDeselect && s.forEach((i) => this.options.onDeselect(i)), (t.length > 0 || s.length > 0) && this.options.onChange && this.options.onChange(this.getSelected());
  }
  open() {
    P.debug(`[${this.instanceId}] open() called`, { isOpen: this.isOpen }), !this.isOpen && (this.isOpen = !0, this.element.classList.add("ms--open"), this.dropdown.classList.add("ms__dropdown--visible"), P.info(`[${this.instanceId}] Dropdown opened`), this.input.placeholder = this.getPlaceholderText(), !this.options.isMultipleEnabled && this.options.isSearchEnabled && (this.input.value = this.searchTerm), this.options.searchCallback && this.options.isKeepOptionsOnSearch && !this.searchTerm && (this.filteredOptions = [...this.allOptions], P.debug(`[${this.instanceId}] Showing ${this.allOptions.length} initial options on open`)), this.renderDropdown(), this.positionDropdown(), this.hint && (this.hint.classList.add("ms__hint--visible"), this.positionHint()));
  }
  close() {
    P.debug(`[${this.instanceId}] close() called`, { isOpen: this.isOpen }), this.isOpen && (this.isOpen = !1, this.element.classList.remove("ms--open"), this.dropdown.classList.remove("ms__dropdown--visible"), this.hint && this.hint.classList.remove("ms__hint--visible"), this.options.shouldKeepSearchOnClose || (this.searchTerm = "", (this.options.isMultipleEnabled || this.options.isSearchEnabled) && (this.input.value = ""), this.filteredOptions = [...this.allOptions]), this.focusedIndex = -1, this.destroyAllOptionTooltips(), this.renderBadges(), this.dropdownCleanup && (this.dropdownCleanup(), this.dropdownCleanup = null), this.hintCleanup && (this.hintCleanup(), this.hintCleanup = null), this.dropdownPlacement = null, P.debug(`[${this.instanceId}] Dropdown closed`));
  }
  /**
   * Anchor a floating panel (dropdown or selected-items popover) below/above the input with
   * placement-locking and width-syncing. Returns the `autoUpdate` cleanup.
   *
   * Both panels share: anchor on input, sync width, default to 'bottom-start', flip on first
   * compute then lock the resulting placement, optionally clamp by dropdownMin/MaxWidth.
   */
  anchorFloatingPanel(e, t) {
    const s = {
      ...ot,
      getOffsetParent: () => ys(this.input)
    };
    return _e(this.input, e, () => {
      var l;
      e.style.width = `${this.input.offsetWidth}px`, this.options.dropdownMinWidth && (e.style.minWidth = this.options.dropdownMinWidth), t.applyMaxWidth && this.options.dropdownMaxWidth && (e.style.maxWidth = this.options.dropdownMaxWidth);
      const i = ((l = t.isLocked) == null ? void 0 : l.call(t)) ?? !0, r = t.getPlacement(), n = i && r ? r : "bottom-start", a = [
        ye(4),
        ...i && r ? [] : [rt()],
        we({ padding: 8 })
      ];
      ke(this.input, e, { placement: n, strategy: "fixed", middleware: a, platform: s }).then(({ x: h, y: c, placement: p }) => {
        var u;
        r || t.setPlacement(p), Object.assign(e.style, {
          position: "fixed",
          left: `${h}px`,
          top: `${c}px`
        }), this.verifyPanelLanded(e, h, c), (u = t.afterPosition) == null || u.call(t);
      });
    });
  }
  /**
   * Sanity-check that the browser placed the panel where we told it to. With `position: fixed`
   * and no transformed/perspective/filter ancestor, `left: ${x}px` must render at viewport-x = x.
   * If the rendered position drifts, the consumer has an ancestor that establishes a fixed
   * containing block but isn't on our reliable-anchors list (likely `contain: paint|layout|strict`
   * or `container-type` — which the spec says creates a CB but the browser's actual behavior
   * varies across shadow-DOM scenarios). We can't fix it from inside the library, but we can
   * surface a clear warning so the developer knows where to look.
   *
   * Fires at most once per multiselect instance to avoid flooding the console during autoUpdate.
   */
  verifyPanelLanded(e, t, s) {
    if (this.positioningDriftWarned) return;
    const i = e.getBoundingClientRect(), r = i.x - t, n = i.y - s;
    if (Math.abs(r) < 1 && Math.abs(n) < 1) return;
    this.positioningDriftWarned = !0;
    const a = ws(this.input, r, n), l = a ? `<${a.tagName.toLowerCase()}${a.id ? "#" + a.id : ""}${typeof a.className == "string" && a.className ? "." + a.className.split(/\s+/).filter(Boolean).slice(0, 2).join(".") : ""}>` : "an ancestor element (could not auto-identify)", h = a ? ks(a) : "";
    console.warn(
      `[@keenmate/web-multiselect] Dropdown panel rendered ${r.toFixed(0)}px / ${n.toFixed(0)}px away from where the library positioned it. Most likely culprit: ${l}` + (h ? ` (has ${h})` : "") + ".\nAn ancestor of <web-multiselect> establishes a fixed-positioning containing block that the library's heuristic doesn't recognize. Fix on your side: replace the property with `transform: translateZ(0)` on that ancestor, OR move the trigger out of that ancestor's subtree. If neither is acceptable, please file an issue at https://github.com/keenmate/web-multiselect/issues with the ancestor's computed CSS."
    );
  }
  positionDropdown() {
    this.dropdownCleanup = this.anchorFloatingPanel(this.dropdown, {
      getPlacement: () => this.dropdownPlacement,
      setPlacement: (e) => {
        this.dropdownPlacement = e, P.debug(`[${this.instanceId}] Locked dropdown placement:`, e);
      },
      isLocked: () => !!this.options.isPlacementLocked,
      applyMaxWidth: !0,
      afterPosition: () => {
        this.hint && this.isOpen && this.positionHint();
      }
    });
  }
  positionHint() {
    this.hint && (this.hintCleanup && this.hintCleanup(), this.hintCleanup = _e(
      this.input,
      this.hint,
      () => {
        let e = "top-start";
        this.dropdownPlacement && (this.dropdownPlacement.startsWith("bottom") ? e = this.dropdownPlacement.replace("bottom", "top") : this.dropdownPlacement.startsWith("top") && (e = this.dropdownPlacement.replace("top", "bottom"))), ke(this.input, this.hint, {
          placement: e,
          strategy: "fixed",
          middleware: [
            ye(4),
            // Don't use flip() - we want hint to stay opposite of dropdown
            we({ padding: 8 })
          ]
        }).then(({ x: t, y: s }) => {
          Object.assign(this.hint.style, {
            position: "fixed",
            left: `${t}px`,
            top: `${s}px`
          });
        });
      }
    ));
  }
  parseInitialSelection() {
    const e = this.element.dataset.initialValues;
    if (e)
      try {
        JSON.parse(e).forEach((s) => {
          this.selectedValues.add(String(s));
        }), this.reconcileSelectedOptions(), this.renderBadges();
      } catch (t) {
        x.error(`[${this.instanceId}] Failed to parse initial values:`, t);
      }
  }
  /**
   * Resolve any `selectedValues` entries that don't yet have a matching
   * `selectedOptions` object by looking them up in the current `allOptions`.
   * Idempotent; safe to call after init *and* after `options` is replaced
   * (e.g., async fetch, `searchCallback` result, or late `element.options =`
   * assignment). Without this, `initial-values` declared before options
   * arrive ends up with phantom values that `getValue()` can never report.
   */
  reconcileSelectedOptions() {
    this.selectedValues.size === 0 || this.allOptions.length === 0 || this.selectedValues.forEach((e) => {
      if (this.selectedOptions.has(e)) return;
      const t = this.allOptions.find((s) => String(this.getItemValue(s)) === e);
      t && this.selectedOptions.set(e, t);
    });
  }
  toggleSelectedPopover() {
    this.showSelectedPopover ? this.hideSelectedPopover() : this.showPopover();
  }
  showPopover() {
    P.debug(`[${this.instanceId}] showPopover() called`), this.isOpen && this.close(), this.showSelectedPopover = !0, this.renderSelectedPopover(), this.selectedPopover.classList.add("ms__selected-popover--visible");
    const e = this.options.virtualScrollThreshold ?? 100;
    this.selectedValues.size >= e && this.selectedPopover.classList.add("ms__selected-popover--virtual"), this.positionSelectedPopover();
  }
  hideSelectedPopover() {
    var e;
    P.debug(`[${this.instanceId}] hideSelectedPopover() called`), this.showSelectedPopover = !1, this.selectedPopover.classList.remove("ms__selected-popover--visible"), this.selectedPopover.classList.remove("ms__selected-popover--virtual"), this.selectedPopoverPlacement = null, this.selectedPopoverVirtualScroll && (this.selectedPopoverVirtualScroll.destroy(), this.selectedPopoverVirtualScroll = null, this.selectedPopoverContainer = null), this.selectedPopoverCleanup && (this.selectedPopoverCleanup(), this.selectedPopoverCleanup = null);
    for (const t of Array.from(this.tooltips.keys()))
      t.startsWith("popover-") && ((e = this.tooltips.get(t)) == null || e.destroy(), this.tooltips.delete(t));
  }
  renderSelectedPopover() {
    const e = Array.from(this.selectedOptions.values()), t = this.selectedValues.size, s = this.options.virtualScrollThreshold ?? 100;
    if (t >= s) {
      this.renderSelectedPopoverVirtual(e, t);
      return;
    }
    this.selectedPopover.innerHTML = `
            <div class="ms__selected-popover-header">
                <span>Selected Items (${t})</span>
                <button type="button" class="ms__selected-popover-close" aria-label="Close"></button>
            </div>
            <div class="ms__selected-popover-body">
                ${e.map((i) => this.renderBadgeHTML(i, { displayMode: this.options.badgesDisplayMode || "badges", isInPopover: !0 })).join("")}
            </div>
        `, this.attachBadgeTooltips(this.selectedPopover);
  }
  renderSelectedPopoverVirtual(e, t) {
    if (this.selectedPopoverVirtualScroll) {
      const a = this.selectedPopover.querySelector(".ms__selected-popover-header span");
      a && (a.textContent = `Selected Items (${t})`);
    } else {
      const a = this.options.badgeHeight ?? 36, l = `
                <div class="ms__selected-popover-header">
                    <span>Selected Items (${t})</span>
                    <button type="button" class="ms__selected-popover-close" aria-label="Close"></button>
                </div>
                <div class="ms__selected-popover-body ms__selected-popover-body--virtual" style="height: 18rem; overflow-y: auto; position: relative; --ms-badge-height-virtual: ${a}px;"></div>
            `;
      this.selectedPopover.innerHTML = l, this.selectedPopoverContainer = this.selectedPopover.querySelector(".ms__selected-popover-body");
    }
    if (!this.selectedPopoverContainer) return;
    const r = (this.options.badgeHeight ?? 36) + 4, n = this.options.virtualScrollBuffer ?? 10;
    requestAnimationFrame(() => {
      this.selectedPopoverContainer && (this.selectedPopoverVirtualScroll ? this.selectedPopoverVirtualScroll.setItems(e) : this.selectedPopoverVirtualScroll = new We({
        container: this.selectedPopoverContainer,
        itemHeight: r,
        items: e,
        renderItem: (a) => this.renderBadgeHTML(a, { displayMode: this.options.badgesDisplayMode || "badges", isInPopover: !0 }),
        bufferSize: n,
        onVisibleRangeChange: () => {
          this.attachBadgeTooltips(this.selectedPopoverContainer);
        }
      }));
    });
  }
  /**
   * Render a removable badge for a selected option (used by the badges/partial display modes
   * and by the selected-items popover).
   *
   * - In the popover, `renderSelectedItemContentCallback` and `getSelectedItemClassCallback` win
   *   over the regular badge callbacks; that's how consumers customize popover items independently.
   * - The `data-value` and aria-label both go through `getItemBadgeDisplayValue` so badge text and
   *   accessible name stay in sync.
   */
  renderBadgeHTML(e, t) {
    const s = this.getItemValue(e);
    let i;
    const r = t.isInPopover ? this.options.renderSelectedItemContentCallback : void 0;
    if (r) {
      const h = r(e);
      i = typeof h == "string" ? h : h.outerHTML;
    } else if (this.options.renderBadgeContentCallback) {
      const h = this.options.renderBadgeContentCallback(e, t);
      i = typeof h == "string" ? h : h.outerHTML;
    } else
      i = this.getItemBadgeDisplayValue(e);
    const n = t.isInPopover ? this.options.getSelectedItemClassCallback || this.options.getBadgeClassCallback : this.options.getBadgeClassCallback;
    let a = "ms__badge";
    if (n) {
      const h = n(e), c = Array.isArray(h) ? h : [h];
      a += " " + c.filter((p) => p).join(" ");
    }
    const l = this.getItemBadgeDisplayValue(e);
    return `
            <div class="${a}">
                <span class="ms__badge-text">${i}</span>
                <button type="button" class="ms__badge-remove" data-value="${s}" aria-label="Remove ${l}"></button>
            </div>
        `;
  }
  handleSelectedPopoverClick(e) {
    if (e.stopPropagation(), e.target.closest(".ms__selected-popover-close")) {
      e.preventDefault(), this.hideSelectedPopover();
      return;
    }
    const s = e.target.closest(".ms__badge-remove");
    if (s) {
      e.preventDefault();
      const i = s.dataset.value, r = this.selectedOptions.get(i);
      r && this.interactiveDeselect(r) && (this.renderSelectedPopover(), this.selectedValues.size === 0 && this.hideSelectedPopover());
    }
  }
  positionSelectedPopover() {
    this.selectedPopoverCleanup = this.anchorFloatingPanel(this.selectedPopover, {
      getPlacement: () => this.selectedPopoverPlacement,
      setPlacement: (e) => {
        this.selectedPopoverPlacement = e, P.debug(`[${this.instanceId}] Locked popover placement:`, e);
      }
    });
  }
  // ========================================================================
  // FORM INTEGRATION
  // ========================================================================
  updateHiddenInput() {
    if (!this.options.formFieldId) return;
    this.hiddenInputs.forEach((i) => i.remove()), this.hiddenInputs = [];
    const e = this.options.valueFormat || "json", t = Array.from(this.selectedOptions.values()).map((i) => this.getItemValue(i)), s = this.options.hostElement || this.element;
    if (e === "array")
      t.forEach((i) => {
        const r = document.createElement("input");
        r.type = "hidden", r.name = `${this.options.formFieldId}[]`, r.value = String(i), s.appendChild(r), this.hiddenInputs.push(r);
      });
    else {
      const i = document.createElement("input");
      i.type = "hidden", i.name = this.options.formFieldId, i.id = this.options.formFieldId, i.value = this.getFormValue(), s.appendChild(i), this.hiddenInputs.push(i);
    }
  }
  getFormValue() {
    const e = Array.from(this.selectedOptions.values()).map((s) => this.getItemValue(s));
    return this.options.getValueFormatCallback ? this.options.getValueFormatCallback(e) : (this.options.valueFormat || "json") === "csv" ? e.join(",") : JSON.stringify(e);
  }
  // ========================================================================
  // PUBLIC API
  // ========================================================================
  getSelected() {
    return Array.from(this.selectedOptions.values());
  }
  setSelected(e) {
    this.selectedValues = new Set(e.map((t) => String(t))), this.selectedOptions.clear(), e.forEach((t) => {
      const s = String(t), i = this.allOptions.find((r) => String(this.getItemValue(r)) === s);
      i && this.selectedOptions.set(s, i);
    }), this.renderDropdown(), this.renderBadges(), this.updateHiddenInput();
  }
  /**
   * Merge a partial config update into the live picker without tearing down the DOM.
   *
   * Handles the cheap structural toggles inline (no-checkboxes class, badges-position class,
   * input placeholder, search-input mode) and re-renders dropdown + badges + hidden inputs.
   *
   * Returns `true` if the change could be applied in place. Returns `false` for changes that
   * truly require rebuilding the DOM scaffolding (currently: adding/removing the `searchHint`
   * element, since it's only created in `buildHTML` if a hint string was provided). The caller
   * should fall back to destroy + re-init in that case.
   */
  updateOptions(e) {
    const t = !!this.hint, s = "searchHint" in e ? !!e.searchHint : t;
    if (t !== s) return !1;
    if (Object.assign(this.options, e), "options" in e && e.options !== void 0 && (this.allOptions = e.options, this.filteredOptions = this.searchTerm ? this.filteredOptions : [...this.allOptions], this.reconcileSelectedOptions()), this.element.classList.toggle(
      "ms--no-checkboxes",
      !this.options.isCheckboxesShown || !this.options.isMultipleEnabled
    ), "badgesPosition" in e) {
      this.effectiveBadgesPosition = this.options.badgesPosition || "bottom", this.isRTL && (this.effectiveBadgesPosition === "left" ? this.effectiveBadgesPosition = "right" : this.effectiveBadgesPosition === "right" && (this.effectiveBadgesPosition = "left"));
      const i = this.element.querySelector(".ms__wrapper");
      i == null || i.classList.toggle(
        "ms__wrapper--inline",
        this.effectiveBadgesPosition === "left" || this.effectiveBadgesPosition === "right"
      );
    }
    return this.isOpen || (this.input.placeholder = this.getPlaceholderText()), "searchInputMode" in e && (this.input.readOnly = this.options.searchInputMode === "readonly", this.input.style.display = this.options.searchInputMode === "hidden" ? "none" : ""), "searchHint" in e && this.hint && (this.hint.textContent = this.options.searchHint || ""), this.renderDropdown(), this.renderBadges(), this.updateHiddenInput(), !0;
  }
  get selectedItem() {
    return this.selectedOptions.size === 0 ? null : Array.from(this.selectedOptions.values())[0];
  }
  get selectedValue() {
    if (!this.options.valueMember && !this.options.getValueCallback)
      return null;
    if (this.selectedOptions.size === 0)
      return this.options.isMultipleEnabled ? [] : null;
    const e = Array.from(this.selectedOptions.values()).map((t) => this.getItemValue(t));
    return this.options.isMultipleEnabled ? e : e[0] ?? null;
  }
  getValue() {
    if (this.selectedOptions.size === 0)
      return this.options.isMultipleEnabled ? [] : null;
    const e = Array.from(this.selectedOptions.values()).map((t) => this.getItemValue(t));
    return this.options.isMultipleEnabled ? e : e[0] ?? null;
  }
  // ========================================================================
  // TOOLTIPS (badge text, badge-remove buttons, action buttons)
  // ========================================================================
  /**
   * Create or replace a tracked tooltip with the given id. Replacing destroys the old one,
   * which is the normal flow when re-rendering badges/actions.
   */
  spawnTooltip(e) {
    var r;
    (r = this.tooltips.get(e.id)) == null || r.destroy();
    const t = this.element.getRootNode(), s = t instanceof ShadowRoot ? t : null, i = new _s({
      trigger: e.trigger,
      container: this.options.container ?? s ?? document.body,
      content: e.content,
      placement: e.placement ?? this.options.badgeTooltipPlacement ?? "top",
      offsetDistance: e.offsetDistance ?? this.options.badgeTooltipOffset ?? 8,
      showDelay: e.showDelay ?? this.options.badgeTooltipDelay ?? 100,
      cssClass: e.cssClass,
      visibleClass: e.visibleClass,
      followCursor: e.followCursor,
      onBeforeShow: e.onBeforeShow
    });
    this.tooltips.set(e.id, i);
  }
  destroyAllTooltips() {
    this.tooltips.forEach((e) => e.destroy()), this.tooltips.clear();
  }
  /** Build the badge-text tooltip content (callback overrides; default = displayValue + optional subtitle on next line). */
  buildBadgeTooltipContent(e) {
    if (this.options.getBadgeTooltipCallback) return this.options.getBadgeTooltipCallback(e);
    const t = this.getItemBadgeDisplayValue(e), s = this.getItemSubtitle(e);
    return s ? `${t}
${s}` : t;
  }
  /** Build the remove-button tooltip text (callback > format string with {0} > "Remove {name}"). */
  buildRemoveButtonTooltipText(e, t) {
    return t && this.options.getRemoveButtonTooltipCallback ? this.options.getRemoveButtonTooltipCallback(t) : this.options.removeButtonTooltipText ? this.options.removeButtonTooltipText.replace("{0}", e) : `Remove ${e}`;
  }
  attachBadgeTooltips(e) {
    if (!this.options.isBadgeTooltipsEnabled) return;
    const t = !!e, s = e || this.badgesContainer, i = t ? "popover-" : "";
    if (s.querySelectorAll(".ms__badge:not(.ms__badge--more)").forEach((n) => {
      const a = n.querySelector(".ms__badge-remove");
      if (!a) return;
      const l = a.dataset.value, h = this.selectedOptions.get(l);
      if (!h) return;
      const c = `${i}${l}`, p = `${i}${l}-remove`, u = n.querySelector(".ms__badge-text");
      u && this.spawnTooltip({
        id: c,
        trigger: u,
        content: this.buildBadgeTooltipContent(h)
      });
      const m = this.getItemBadgeDisplayValue(h);
      this.spawnTooltip({
        id: p,
        trigger: a,
        content: this.buildRemoveButtonTooltipText(m, h),
        // Keep parent badge tooltip from overlapping the remove-button tooltip.
        onBeforeShow: () => {
          var b;
          return (b = this.tooltips.get(c)) == null ? void 0 : b.hideImmediate();
        }
      });
    }), !t) {
      const n = this.badgesContainer.querySelector(".ms__badge--more"), a = n == null ? void 0 : n.querySelector(".ms__badge-remove");
      if (a && a.dataset.action === "remove-hidden") {
        const l = this.options.badgesMaxVisible || 3, h = this.selectedOptions.size - l;
        this.spawnTooltip({
          id: "more-badge-remove",
          trigger: a,
          content: this.buildRemoveButtonTooltipText(`${h} hidden items`)
        });
      }
    }
  }
  /** Build the option tooltip content (callback overrides; default = displayValue + optional subtitle on next line). */
  buildOptionTooltipContent(e) {
    if (this.options.getOptionTooltipCallback) return this.options.getOptionTooltipCallback(e);
    const t = this.getItemDisplayValue(e), s = this.getItemSubtitle(e);
    return s ? `${t}
${s}` : t;
  }
  /**
   * Attach hover tooltips to the currently rendered dropdown options. Prunes existing option
   * tooltips first, so it's safe to call on every render and on every virtual-scroll range change
   * (where option DOM is recycled). Each option resolves its source object via `data-index` into
   * `filteredOptions`, the same global index `renderOption` was given.
   */
  attachOptionTooltips() {
    if (this.destroyAllOptionTooltips(), !this.options.isOptionTooltipsEnabled) return;
    this.dropdown.querySelectorAll(".ms__option").forEach((t) => {
      const s = t, i = parseInt(s.dataset.index ?? "-1", 10);
      if (i < 0) return;
      const r = this.filteredOptions[i];
      if (!r) return;
      const n = this.buildOptionTooltipContent(r);
      n && this.spawnTooltip({
        id: `option-${i}`,
        trigger: s,
        content: n,
        // Default to `top-start` (anchored to the row's start edge) so the tooltip doesn't
        // center on a full-width row. Falls through to the badge settings for delay/offset.
        placement: this.options.optionTooltipPlacement ?? "top-start",
        offsetDistance: this.options.optionTooltipOffset ?? this.options.badgeTooltipOffset ?? 8,
        showDelay: this.options.optionTooltipDelay ?? this.options.badgeTooltipDelay ?? 100,
        cssClass: "ms__option-tooltip",
        visibleClass: "ms__option-tooltip--visible",
        followCursor: this.options.isOptionTooltipFollowCursor
      });
    });
  }
  /**
   * Destroy only the option tooltips (prefixed `option-`). Called before re-rendering or
   * recycling the options list so per-option tooltip state doesn't leak.
   */
  destroyAllOptionTooltips() {
    var e;
    for (const t of Array.from(this.tooltips.keys()))
      t.startsWith("option-") && ((e = this.tooltips.get(t)) == null || e.destroy(), this.tooltips.delete(t));
  }
  attachActionButtonTooltips() {
    this.dropdown.querySelectorAll(".ms__action-btn").forEach((t) => {
      var h, c;
      const s = t, i = s.dataset.action;
      if (!i) return;
      const r = parseInt(s.dataset.buttonIndex || "-1"), n = r >= 0 ? (h = this.options.actionButtons) == null ? void 0 : h[r] : (c = this.options.actionButtons) == null ? void 0 : c.find((p) => p.action === i);
      if (!n) return;
      const a = n.getTooltipCallback ? n.getTooltipCallback(this) : n.tooltip;
      if (!a) return;
      const l = `action-${r >= 0 ? r : i}`;
      this.spawnTooltip({ id: l, trigger: s, content: a });
    });
  }
  /**
   * Destroy only the action-button tooltips. Called from `renderDropdown`/`renderDropdownVirtual`
   * before rebuilding the actions row, so per-button tooltip state doesn't leak.
   */
  destroyAllActionButtonTooltips() {
    var e;
    for (const t of Array.from(this.tooltips.keys()))
      t.startsWith("action-") && ((e = this.tooltips.get(t)) == null || e.destroy(), this.tooltips.delete(t));
  }
  /**
   * Destroy main-badges-container tooltips. Called before re-rendering the badges container.
   * Popover tooltips (prefixed `popover-`) survive — they're owned by the popover lifecycle and
   * cleaned up in `hideSelectedPopover`. Action-button tooltips (prefixed `action-`) survive too.
   */
  destroyAllBadgeTooltips() {
    var e;
    for (const t of Array.from(this.tooltips.keys()))
      !t.startsWith("action-") && !t.startsWith("popover-") && ((e = this.tooltips.get(t)) == null || e.destroy(), this.tooltips.delete(t));
  }
  // ========================================================================
  // PUBLIC API
  // ========================================================================
  destroy() {
    this.destroyAllTooltips(), this.searchDebounceTimer && (clearTimeout(this.searchDebounceTimer), this.searchDebounceTimer = void 0), this.abortInFlightSearch(), this.dropdownCleanup && this.dropdownCleanup(), this.hintCleanup && this.hintCleanup(), this.selectedPopoverCleanup && this.selectedPopoverCleanup(), this.documentClickHandler && (document.removeEventListener("click", this.documentClickHandler), this.documentClickHandler = null), this.documentKeydownHandler && (document.removeEventListener("keydown", this.documentKeydownHandler), this.documentKeydownHandler = null), this.virtualScroll && (this.virtualScroll.destroy(), this.virtualScroll = null), this.dropdown && this.dropdown.remove(), this.hint && this.hint.remove(), this.selectedPopover && this.selectedPopover.remove(), this.element.innerHTML = "", this.element.classList.remove("ms", "ms--open", "ms--no-checkboxes"), oe.info(`[${this.instanceId}] Component destroyed`);
  }
}
const Cs = `@layer variables,component,overrides;@layer variables{:host{display:block;--ms-rem: 10px;font-family:var(--ms-font-family, var(--base-font-family, inherit));--ms-accent-color: var(--base-accent-color, #3b82f6);--ms-accent-color-hover: var(--base-accent-color-hover, #2563eb);--ms-accent-color-active: var(--base-accent-color-active, #1d4ed8);--ms-accent-color-light: var(--base-accent-color-light, light-dark(#eff6ff, #1e3a5f));--ms-accent-color-light-hover: var(--base-accent-color-light-hover, light-dark(#e0f2fe, #264a73));--ms-text-color-1: var(--base-text-color-1, light-dark(#111827, #f5f5f5));--ms-text-color-2: var(--base-text-color-2, light-dark(#353b47, #d4d4d4));--ms-text-color-3: var(--base-text-color-3, light-dark(#6b7280, #a3a3a3));--ms-text-color-4: var(--base-text-color-4, light-dark(#a0a3a9, #737373));--ms-text-color-on-accent: var(--base-text-color-on-accent, #ffffff);--ms-text-primary: var(--ms-text-color-1);--ms-text-secondary: var(--ms-text-color-3);--ms-primary-bg: var(--base-hover-bg, color-mix(in srgb, var(--ms-text-color-1) 8%, var(--base-main-bg, light-dark(#ffffff, #1a1a1a))));--ms-primary-bg-hover: var(--base-active-bg, color-mix(in srgb, var(--ms-text-color-1) 14%, var(--base-main-bg, light-dark(#ffffff, #1a1a1a))));--ms-border-color: var(--base-border-color, light-dark(#e5e7eb, #3a3a3a));--ms-border: var(--base-border, 1px solid var(--ms-border-color));--ms-input-bg: var(--base-input-bg, light-dark(#ffffff, #1a1a1a));--ms-input-color: var(--base-input-color, var(--ms-text-color-1));--ms-input-border: var(--base-input-border, 1px solid var(--ms-border-color));--ms-input-border-hover: var(--base-input-border-hover, 1px solid var(--ms-accent-color));--ms-input-border-focus: var(--base-input-border-focus, 1px solid var(--ms-accent-color));--ms-input-placeholder-color: var(--base-input-placeholder-color, var(--ms-text-color-4));--ms-input-bg-disabled: var(--base-input-bg-disabled, rgba(107, 114, 128, .05));--ms-toggle-icon-color: var(--ms-text-color-3);--ms-toggle-icon-color-open: var(--ms-text-color-3);--ms-counter-badge-bg: var(--ms-accent-color);--ms-counter-badge-bg-hover: var(--ms-accent-color-hover);--ms-counter-badge-color: var(--ms-text-color-on-accent);--ms-hint-bg: var(--base-main-bg, light-dark(#ffffff, #1a1a1a));--ms-hint-color: var(--ms-text-color-4);--ms-hint-border-color: var(--ms-border-color);--ms-dropdown-bg: var(--base-dropdown-bg, var(--base-elevated-bg, light-dark(#ffffff, #1a1a1a)));--ms-dropdown-text-color: var(--ms-text-color-1);--ms-dropdown-border-color: var(--ms-border-color);--ms-dropdown-box-shadow-semantic: var(--base-dropdown-box-shadow, 0 20px 25px -5px rgb(0 0 0 / .1), 0 8px 10px -6px rgb(0 0 0 / .1));--ms-actions-bg: var(--base-main-bg, light-dark(#ffffff, #1a1a1a));--ms-actions-border-color: var(--ms-border-color);--ms-action-button-bg: transparent;--ms-action-button-bg-hover: var(--ms-primary-bg);--ms-action-button-border-color: var(--ms-border-color);--ms-action-button-border-color-hover: var(--ms-accent-color);--ms-action-button-color: var(--ms-text-color-1);--ms-group-border-color: var(--ms-border-color);--ms-option-text-color: var(--ms-text-color-1);--ms-option-bg: transparent;--ms-option-bg-hover: var(--ms-primary-bg);--ms-option-color-hover: inherit;--ms-option-bg-focused: var(--ms-primary-bg);--ms-option-color-focused: inherit;--ms-option-outline-color-focused: var(--ms-accent-color);--ms-option-bg-selected: color-mix(in srgb, var(--ms-accent-color) 10%, transparent);--ms-option-bg-matched: color-mix(in srgb, var(--ms-accent-color) 8%, transparent);--ms-option-color-matched: inherit;--ms-option-border-matched-color: color-mix(in srgb, var(--ms-accent-color) 40%, transparent);--ms-option-title-color: var(--ms-text-color-1);--ms-option-subtitle-color: var(--ms-text-color-3);--ms-option-mark-bg: color-mix(in srgb, var(--ms-accent-color) 20%, transparent);--ms-option-mark-color: inherit;--ms-loading-color: var(--ms-text-color-3);--ms-badge-bg: var(--ms-accent-color-light);--ms-badge-bg-hover: var(--base-hover-bg, var(--ms-input-bg));--ms-badge-bg-active: var(--ms-accent-color-light-hover);--ms-badge-text-bg-hover: var(--base-hover-bg, var(--ms-input-bg));--ms-badge-text-color-hover: var(--ms-badge-text-color);--ms-badge-counter-border-color: var(--ms-border-color);--ms-badge-counter-text-bg: var(--ms-primary-bg-hover);--ms-badge-counter-text-color: var(--ms-text-color-1);--ms-badge-counter-remove-bg: var(--ms-text-color-3);--ms-badge-counter-remove-bg-hover: var(--ms-text-color-1);--ms-badge-counter-remove-color: var(--ms-text-color-on-accent);--ms-counter-wrapper-border-color: var(--ms-border-color);--ms-count-clear-bg-hover: var(--ms-accent-color);--ms-tooltip-bg: var(--base-tooltip-bg, var(--base-inverse-bg, light-dark(#333333, #f5f5f5)));--ms-tooltip-text-color: var(--base-tooltip-text-color, light-dark(#ffffff, #1a1a1a));--ms-selected-popover-bg: var(--base-dropdown-bg, var(--base-elevated-bg, light-dark(#ffffff, #1a1a1a)));--ms-selected-popover-border-color: var(--ms-border-color);--ms-selected-popover-header-border-color: var(--ms-border-color);--ms-selected-popover-close-bg-hover: var(--ms-accent-color);--ms-input-padding: calc(.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-input-padding-right: calc(4 * var(--ms-rem));--ms-input-padding-h: calc(1.2 * var(--ms-rem));--ms-input-height: calc(var(--base-input-size-md-height, 3.5) * var(--ms-rem));--ms-input-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-input-border-width: 1px;--ms-input-border-radius: var(--ms-border-radius-md);--ms-input-text: var(--ms-text-color-1);--ms-input-bg-disabled: rgba(107, 114, 128, .05);--ms-input-size-xs-font: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-input-size-xs-padding-v: calc(.4 * var(--ms-rem));--ms-input-size-xs-padding-h: calc(.8 * var(--ms-rem));--ms-input-size-xs-height: calc(var(--base-input-size-xs-height, 3.1) * var(--ms-rem));--ms-input-size-sm-font: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-input-size-sm-padding-v: calc(.5 * var(--ms-rem));--ms-input-size-sm-padding-h: calc(1 * var(--ms-rem));--ms-input-size-sm-height: calc(var(--base-input-size-sm-height, 3.3) * var(--ms-rem));--ms-input-size-md-font: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-input-size-md-padding-v: calc(.8 * var(--ms-rem));--ms-input-size-md-padding-h: calc(1.2 * var(--ms-rem));--ms-input-size-md-height: calc(var(--base-input-size-md-height, 3.5) * var(--ms-rem));--ms-input-size-lg-font: calc(var(--base-font-size-base, 1.6) * var(--ms-rem));--ms-input-size-lg-padding-v: calc(1 * var(--ms-rem));--ms-input-size-lg-padding-h: calc(1.4 * var(--ms-rem));--ms-input-size-lg-height: calc(var(--base-input-size-lg-height, 3.8) * var(--ms-rem));--ms-input-size-xl-font: calc(var(--base-font-size-lg, 1.8) * var(--ms-rem));--ms-input-size-xl-padding-v: calc(1.2 * var(--ms-rem));--ms-input-size-xl-padding-h: calc(1.6 * var(--ms-rem));--ms-input-size-xl-height: calc(var(--base-input-size-xl-height, 4.1) * var(--ms-rem));--ms-toggle-right: calc(1.2 * var(--ms-rem));--ms-toggle-color: var(--ms-text-color-3);--ms-transform-center-y: translateY(-50%);--ms-transform-rotate-180: 180deg;--ms-counter-offset: calc(3.2 * var(--ms-rem));--ms-counter-padding: calc(.2 * var(--ms-rem)) calc(.4 * var(--ms-rem));--ms-counter-bg: var(--ms-accent-color);--ms-counter-color: var(--ms-text-color-on-accent);--ms-counter-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-counter-font-weight: var(--base-font-weight-semibold, 600);--ms-counter-border-radius: var(--ms-border-radius-sm);--ms-counter-bg-hover: var(--ms-accent-color-hover);--ms-transform-scale-hover: 1.1;--ms-hint-padding: calc(.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-hint-border: 1px solid var(--ms-hint-border-color);--ms-hint-border-radius: var(--ms-border-radius-lg);--ms-hint-box-shadow: 0 4px 6px -1px rgb(0 0 0 / .1), 0 2px 4px -2px rgb(0 0 0 / .1);--ms-hint-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-dropdown-border: var(--base-dropdown-border, 1px solid var(--ms-dropdown-border-color));--ms-dropdown-border-radius: var(--ms-border-radius-lg);--ms-dropdown-box-shadow: 0 20px 25px -5px rgb(0 0 0 / .1), 0 8px 10px -6px rgb(0 0 0 / .1);--ms-options-max-height: calc(32 * var(--ms-rem));--ms-option-color: var(--ms-text-color-1);--ms-z-index-dropdown: 9999;--ms-z-index-sticky: 1;--ms-actions-gap: calc(.4 * var(--ms-rem));--ms-actions-padding: calc(.8 * var(--ms-rem));--ms-actions-border-bottom: 1px solid var(--ms-actions-border-color);--ms-action-btn-padding: calc(.4 * var(--ms-rem)) calc(.8 * var(--ms-rem));--ms-action-btn-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-action-btn-border: var(--ms-border);--ms-action-btn-border-radius: var(--ms-border-radius-sm);--ms-action-btn-bg: transparent;--ms-action-btn-color: inherit;--ms-action-btn-bg-hover: var(--ms-primary-bg);--ms-action-btn-border-color-hover: var(--ms-accent-color);--ms-transform-scale-active: .98;--ms-options-padding: 0;--ms-group-border-top: 1px solid var(--ms-group-border-color);--ms-group-margin-top: calc(.4 * var(--ms-rem));--ms-group-padding-top: calc(.4 * var(--ms-rem));--ms-group-label-padding: calc(.4 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-group-label-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-group-label-font-weight: var(--base-font-weight-semibold, 600);--ms-group-label-color: var(--ms-text-color-3);--ms-group-label-transform: uppercase;--ms-group-label-letter-spacing: .05em;--ms-option-gap: calc(.8 * var(--ms-rem));--ms-option-padding: calc(.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-option-padding-h: calc(1.2 * var(--ms-rem));--ms-option-outline-focused: 2px solid var(--ms-option-outline-color-focused);--ms-option-focus-outline-offset: -2px;--ms-option-border-matched: 3px solid var(--ms-option-border-matched-color);--ms-option-bg-focused-hover: var(--ms-primary-bg);--ms-option-bg-matched-hover: color-mix(in srgb, var(--ms-accent-color) 12%, transparent);--ms-option-bg-selected-focused: color-mix(in srgb, var(--ms-accent-color) 15%, transparent);--ms-option-bg-selected-matched: color-mix(in srgb, var(--ms-accent-color) 15%, transparent);--ms-option-disabled-bg: var(--base-disabled-bg, transparent);--ms-option-bg-disabled-selected: color-mix(in srgb, var(--ms-accent-color) 10%, transparent);--ms-disabled-opacity: .5;--ms-option-content-gap: calc(.8 * var(--ms-rem));--ms-option-icon-size: calc(2 * var(--ms-rem));--ms-option-icon-font-size: calc(var(--base-font-size-base, 1.6) * var(--ms-rem));--ms-option-title-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-option-mark-font-weight: var(--base-font-weight-semibold, 600);--ms-option-subtitle-margin-top: calc(.4 * var(--ms-rem));--ms-option-subtitle-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-option-subtitle-line-height: var(--base-line-height-tight, 1.25);--ms-checkbox-margin-top: calc(.2 * var(--ms-rem));--ms-checkbox-margin-right: 0;--ms-checkbox-margin-bottom: 0;--ms-checkbox-margin-left: 0;--ms-checkbox-size: calc(1.6 * var(--ms-rem));--ms-checkbox-scale: 1;--ms-checkbox-align: center;--ms-checkbox-bg: var(--ms-input-bg);--ms-checkbox-border: var(--ms-border);--ms-checkbox-border-radius: calc(.3 * var(--ms-rem));--ms-checkbox-checked-bg: var(--ms-accent-color);--ms-checkbox-checked-border: 1px solid var(--ms-accent-color);--ms-checkbox-checkmark-color: var(--ms-text-color-on-accent);--ms-checkbox-hover-border-color: var(--ms-accent-color);--ms-checkbox-disabled-bg: var(--ms-primary-bg);--ms-checkbox-disabled-border: var(--ms-border);--ms-checkbox-checked-bg-hover: var(--ms-accent-color-hover);--ms-checkbox-checked-border-color-hover: var(--ms-accent-color-hover);--ms-state-min-height: calc(8 * var(--ms-rem));--ms-empty-padding: calc(1.6 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-empty-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-empty-color: var(--ms-text-color-3);--ms-loader-padding: calc(1.6 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-loader-gap: calc(.8 * var(--ms-rem));--ms-loading-text-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-loading-text-color: var(--ms-text-color-3);--ms-badges-gap: calc(.8 * var(--ms-rem));--ms-badges-margin-bottom: calc(.8 * var(--ms-rem));--ms-badges-margin-top: calc(.8 * var(--ms-rem));--ms-badges-margin-left: calc(.4 * var(--ms-rem));--ms-badges-margin-right: calc(.4 * var(--ms-rem));--ms-inline-align: center;--ms-badge-gap: calc(.8 * var(--ms-rem));--ms-badge-height: calc(2.7 * var(--ms-rem));--ms-badge-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-badge-font-weight: var(--base-font-weight-semibold, 600);--ms-badge-border-radius: var(--ms-border-radius-sm);--ms-order-first: -1;--ms-badge-text-padding: 0 calc(.8 * var(--ms-rem));--ms-badge-text-bg: var(--ms-accent-color-light);--ms-badge-text-color: var(--ms-accent-color);--ms-badge-text-border: none;--ms-badge-remove-width: calc(2.7 * var(--ms-rem));--ms-badge-remove-bg: var(--ms-accent-color);--ms-badge-remove-color: var(--ms-text-color-on-accent);--ms-badge-remove-border: none;--ms-badge-remove-font-size: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-badge-remove-bg-hover: var(--ms-accent-color-hover);--ms-badge-remove-box-shadow-focus: 0 0 0 2px color-mix(in srgb, var(--ms-accent-color) 50%, transparent);--ms-badge-remove-icon-size: calc(1 * var(--ms-rem));--ms-icon-remove: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path d='M6 6L18 18M18 6L6 18' stroke='black' stroke-width='2.5' stroke-linecap='round' fill='none'/></svg>");--ms-badge-counter-bg: transparent;--ms-badge-counter-border: 1px solid var(--ms-badge-counter-border-color);--ms-badge-counter-border-radius: var(--ms-border-radius-sm);--ms-more-badge-bg: var(--ms-accent-color-light);--ms-more-badge-hover-bg: var(--ms-badge-bg-hover);--ms-more-badge-active-bg: var(--ms-accent-color-light-hover);--ms-count-display-margin-bottom: calc(.8 * var(--ms-rem));--ms-count-display-margin-top: calc(.8 * var(--ms-rem));--ms-count-display-margin-left: calc(.8 * var(--ms-rem));--ms-count-display-margin-right: calc(.8 * var(--ms-rem));--ms-counter-wrapper-bg: transparent;--ms-counter-wrapper-border: var(--ms-border);--ms-counter-wrapper-border-radius: var(--ms-border-radius-sm);--ms-counter-wrapper-padding: calc(.4 * var(--ms-rem)) calc(.8 * var(--ms-rem));--ms-counter-wrapper-gap: calc(.4 * var(--ms-rem));--ms-counter-wrapper-bg-hover: var(--ms-primary-bg);--ms-counter-wrapper-border-color-hover: var(--ms-accent-color);--ms-count-text-bg: transparent;--ms-count-text-border: none;--ms-count-text-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-count-text-color: var(--ms-text-color-1);--ms-count-clear-size: calc(1.6 * var(--ms-rem));--ms-count-clear-bg: transparent;--ms-count-clear-color: var(--ms-text-color-3);--ms-count-clear-font-size: calc(var(--base-font-size-lg, 1.8) * var(--ms-rem));--ms-count-clear-border-radius: var(--ms-border-radius-sm);--ms-count-clear-bg-hover: color-mix(in srgb, var(--ms-accent-color) 20%, transparent);--ms-count-clear-color-hover: var(--ms-accent-color);--ms-count-clear-icon-size: calc(1.4 * var(--ms-rem));--ms-icon-clear: var(--ms-icon-remove);--ms-tooltip-color: var(--ms-tooltip-text-color);--ms-tooltip-padding: calc(.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-tooltip-border-radius: var(--ms-border-radius-lg);--ms-tooltip-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-tooltip-max-width: calc(32 * var(--ms-rem));--ms-tooltip-shadow: 0 2px 8px rgba(0, 0, 0, .15);--ms-tooltip-z-index: 10000;--ms-option-tooltip-bg: var(--ms-tooltip-bg);--ms-option-tooltip-text-color: var(--ms-tooltip-text-color);--ms-option-tooltip-padding: var(--ms-tooltip-padding);--ms-option-tooltip-border-radius: var(--ms-tooltip-border-radius);--ms-option-tooltip-font-size: var(--ms-tooltip-font-size);--ms-option-tooltip-max-width: var(--ms-tooltip-max-width);--ms-option-tooltip-shadow: var(--ms-tooltip-shadow);--ms-option-tooltip-z-index: var(--ms-tooltip-z-index);--ms-z-index-popover: 10000;--ms-selected-popover-width: calc(32 * var(--ms-rem));--ms-selected-popover-max-height: calc(32 * var(--ms-rem));--ms-selected-popover-border: 1px solid var(--ms-selected-popover-border-color);--ms-selected-popover-border-radius: var(--ms-border-radius-lg);--ms-selected-popover-box-shadow: 0 20px 25px -5px rgb(0 0 0 / .1), 0 8px 10px -6px rgb(0 0 0 / .1);--ms-selected-popover-header-padding: calc(.8 * var(--ms-rem)) calc(1.2 * var(--ms-rem));--ms-selected-popover-header-bg: color-mix(in srgb, var(--ms-accent-color) 10%, transparent);--ms-selected-popover-header-border-bottom: 1px solid var(--ms-selected-popover-header-border-color);--ms-selected-popover-header-font-size: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-selected-popover-header-font-weight: var(--base-font-weight-semibold, 600);--ms-selected-popover-header-color: var(--ms-text-color-1);--ms-popover-close-size: calc(2.4 * var(--ms-rem));--ms-selected-popover-close-bg: transparent;--ms-selected-popover-close-color: var(--ms-text-color-3);--ms-selected-popover-close-font-size: calc(var(--base-font-size-xl, 2) * var(--ms-rem));--ms-selected-popover-close-border-radius: var(--ms-border-radius-sm);--ms-selected-popover-close-bg-hover: color-mix(in srgb, var(--ms-accent-color) 20%, transparent);--ms-selected-popover-close-color-hover: var(--ms-accent-color);--ms-selected-popover-close-icon-size: calc(1.4 * var(--ms-rem));--ms-selected-popover-body-gap: calc(.4 * var(--ms-rem));--ms-selected-popover-body-padding: calc(.8 * var(--ms-rem));--ms-selected-popover-body-max-height: calc(28.8 * var(--ms-rem));--ms-font-size-2xs: calc(var(--base-font-size-2xs, 1) * var(--ms-rem));--ms-font-size-xs: calc(var(--base-font-size-xs, 1.2) * var(--ms-rem));--ms-font-size-sm: calc(var(--base-font-size-sm, 1.4) * var(--ms-rem));--ms-font-size-base: calc(var(--base-font-size-base, 1.6) * var(--ms-rem));--ms-font-size-lg: calc(var(--base-font-size-lg, 1.8) * var(--ms-rem));--ms-font-weight-normal: var(--base-font-weight-normal, 400);--ms-font-weight-medium: var(--base-font-weight-medium, 500);--ms-font-weight-semibold: var(--base-font-weight-semibold, 600);--ms-line-height-none: 1;--ms-line-height-tight: var(--base-line-height-tight, 1.25);--ms-line-height-normal: var(--base-line-height-normal, 1.5);--ms-line-height-relaxed: var(--base-line-height-relaxed, 1.75);--ms-border-radius-sm: calc(var(--base-border-radius-sm, .4) * var(--ms-rem));--ms-border-radius-md: calc(var(--base-border-radius-md, .6) * var(--ms-rem));--ms-border-radius-lg: calc(var(--base-border-radius-lg, .8) * var(--ms-rem));--ms-border-radius: var(--ms-border-radius-md);--ms-spacing-xs: calc(.4 * var(--ms-rem));--ms-spacing-sm: calc(.8 * var(--ms-rem));--ms-spacing-md: calc(1.2 * var(--ms-rem));--ms-spacing-lg: calc(1.6 * var(--ms-rem));--ms-transition-fast: .15s;--ms-transition-normal: .2s;--ms-easing-snappy: cubic-bezier(.4, 0, .2, 1);--ms-placeholder-opacity: .6;--ms-disabled-input-opacity: .6;--ms-scrollbar-width: 8px;--ms-scrollbar-track-bg: transparent;--ms-scrollbar-thumb-bg: var(--ms-border-color);--ms-scrollbar-thumb-bg-hover: var(--ms-text-color-3);--ms-scrollbar-thumb-border-radius: 4px;--ms-debug-bg: var(--base-elevated-bg, light-dark(#f9fafb, #2b2b2b));--ms-debug-border-color: var(--ms-border-color);--ms-debug-text-color: var(--ms-text-color-1);--ms-debug-border-radius: var(--ms-border-radius-md);--ms-debug-summary-color: var(--ms-accent-color);--ms-debug-summary-bg-hover: var(--ms-primary-bg);--ms-debug-summary-outline-color: var(--ms-accent-color);--ms-debug-summary-border-radius: var(--ms-border-radius-sm);--ms-debug-stats-bg: var(--base-main-bg, light-dark(#ffffff, #1a1a1a));--ms-debug-stats-border-radius: var(--ms-border-radius-sm);--ms-debug-bullet-color: var(--ms-accent-color)}}@layer component{web-multiselect:not(:defined){display:block;min-height:calc(3.5 * var(--ms-rem));color:transparent!important;background:transparent}.ms__wrapper{display:flex;flex-direction:column;align-items:stretch}.ms__wrapper--inline{flex-direction:row;align-items:var(--ms-inline-align, center)}.ms{position:relative;width:100%}}@layer component{.ms__input-wrapper{position:relative;display:flex;align-items:center}.ms__input{box-sizing:border-box;width:100%;font-family:inherit;height:var(--ms-input-height);padding:var(--ms-input-padding);padding-right:var(--ms-input-padding-right);font-size:var(--ms-input-font-size);border:var(--ms-input-border);border-radius:var(--ms-input-border-radius);background:var(--ms-input-bg);color:var(--ms-input-color);cursor:pointer;transition:border var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__input:hover:not(:focus):not(:disabled){border:var(--ms-input-border-hover)}.ms__input:focus{outline:none;border:var(--ms-input-border-focus)}.ms__input::placeholder{color:var(--ms-input-placeholder-color);opacity:0;transition:opacity var(--ms-transition-fast) var(--ms-easing-snappy)}:host([data-ready]) .ms__input::placeholder{opacity:var(--ms-placeholder-opacity)}.ms__input.ms__input--xs{font-size:var(--ms-input-size-xs-font);padding:var(--ms-input-size-xs-padding-v) var(--ms-input-size-xs-padding-h);padding-right:calc(var(--ms-input-size-xs-padding-h) * 2.5);height:var(--ms-input-size-xs-height)}.ms__input.ms__input--sm{font-size:var(--ms-input-size-sm-font);padding:var(--ms-input-size-sm-padding-v) var(--ms-input-size-sm-padding-h);padding-right:calc(var(--ms-input-size-sm-padding-h) * 2.5);height:var(--ms-input-size-sm-height)}.ms__input.ms__input--lg{font-size:var(--ms-input-size-lg-font);padding:var(--ms-input-size-lg-padding-v) var(--ms-input-size-lg-padding-h);padding-right:calc(var(--ms-input-size-lg-padding-h) * 2.5);height:var(--ms-input-size-lg-height)}.ms__input.ms__input--xl{font-size:var(--ms-input-size-xl-font);padding:var(--ms-input-size-xl-padding-v) var(--ms-input-size-xl-padding-h);padding-right:calc(var(--ms-input-size-xl-padding-h) * 2.5);height:var(--ms-input-size-xl-height)}.ms__toggle{position:absolute;right:var(--ms-toggle-right);top:50%;transform:var(--ms-transform-center-y);pointer-events:none;color:var(--ms-toggle-icon-color);transition:transform var(--ms-transition-fast) var(--ms-easing-snappy)}.ms--open .ms__toggle{transform:var(--ms-transform-center-y) rotate(var(--ms-transform-rotate-180));color:var(--ms-toggle-icon-color-open)}.ms__counter{position:absolute;right:var(--ms-counter-offset);top:50%;transform:var(--ms-transform-center-y);padding:var(--ms-counter-padding);background:var(--ms-counter-badge-bg);color:var(--ms-counter-badge-color);font-size:var(--ms-counter-font-size);font-weight:var(--ms-counter-font-weight);border-radius:var(--ms-counter-border-radius);cursor:pointer;transition:all var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__counter:hover{background:var(--ms-counter-badge-bg-hover);transform:var(--ms-transform-center-y) scale(var(--ms-transform-scale-hover))}.ms__actions{display:flex;flex-direction:column;gap:var(--ms-actions-gap);padding:var(--ms-actions-padding)}.ms__actions--top{border-bottom:var(--ms-actions-border-bottom)}.ms__actions--bottom{flex-direction:column-reverse;border-top:var(--ms-actions-border-bottom)}.ms__actions-row{display:flex;flex-wrap:nowrap;gap:var(--ms-actions-gap)}.ms__actions--wrap .ms__actions-row{flex-wrap:wrap}.ms__actions--sticky{position:sticky;z-index:var(--ms-z-index-sticky);background:var(--ms-actions-bg)}.ms__actions--sticky.ms__actions--top{top:0}.ms__actions--sticky.ms__actions--bottom{bottom:0}.ms__actions--align-stretch .ms__action-btn{flex:1}.ms__actions--align-left .ms__actions-row{justify-content:flex-start}.ms__actions--align-right .ms__actions-row{justify-content:flex-end}.ms__actions--align-center .ms__actions-row{justify-content:center}.ms__actions--align-space-between .ms__actions-row{justify-content:space-between}.ms__action-btn{font-family:inherit;padding:var(--ms-action-btn-padding);font-size:var(--ms-action-btn-font-size);border:var(--ms-action-btn-border);border-radius:var(--ms-action-btn-border-radius);background:var(--ms-action-button-bg);color:var(--ms-action-button-color);cursor:pointer;transition:all var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__action-btn:hover{background:var(--ms-action-button-bg-hover);border-color:var(--ms-action-button-border-color-hover)}.ms__action-btn:active{transform:scale(var(--ms-transform-scale-active))}.ms__action-btn:disabled,.ms__action-btn[disabled]{opacity:var(--ms-disabled-opacity);cursor:not-allowed;pointer-events:none}}@layer component{.ms__hint{display:none;position:fixed;z-index:var(--ms-z-index-popover);padding:var(--ms-hint-padding);background:var(--ms-hint-bg);border:var(--ms-hint-border);border-radius:var(--ms-hint-border-radius);box-shadow:var(--ms-hint-box-shadow);font-size:var(--ms-hint-font-size);color:var(--ms-hint-color);line-height:var(--ms-line-height-relaxed);max-width:100%}.ms__hint--visible{display:block}.ms__dropdown{display:none;position:fixed;font-family:inherit;z-index:var(--ms-z-index-dropdown);background:var(--ms-dropdown-bg);border:var(--ms-dropdown-border);border-radius:var(--ms-dropdown-border-radius);box-shadow:var(--ms-dropdown-box-shadow);max-height:var(--ms-options-max-height);overflow:hidden;color:var(--ms-dropdown-text-color)}.ms__dropdown--visible{display:flex;flex-direction:column}.ms__dropdown-inner{flex:1;overflow-y:auto;overscroll-behavior:contain;touch-action:pan-y;-webkit-overflow-scrolling:touch;scrollbar-width:thin;scrollbar-color:var(--ms-scrollbar-thumb-bg) var(--ms-scrollbar-track-bg)}.ms__dropdown-inner::-webkit-scrollbar{width:var(--ms-scrollbar-width)}.ms__dropdown-inner::-webkit-scrollbar-track{background:var(--ms-scrollbar-track-bg)}.ms__dropdown-inner::-webkit-scrollbar-thumb{background:var(--ms-scrollbar-thumb-bg);border-radius:var(--ms-scrollbar-thumb-border-radius)}.ms__dropdown-inner::-webkit-scrollbar-thumb:hover{background:var(--ms-scrollbar-thumb-bg-hover)}.ms__dropdown--virtual{max-height:none}.ms__dropdown--virtual .ms__dropdown-inner{overflow-y:visible}.ms__badge-tooltip{position:fixed;z-index:var(--ms-tooltip-z-index);opacity:0;visibility:hidden;transition:opacity var(--ms-transition-normal) ease,visibility var(--ms-transition-normal) ease;background:var(--ms-tooltip-bg);color:var(--ms-tooltip-text-color);padding:var(--ms-tooltip-padding);border-radius:var(--ms-tooltip-border-radius);font-size:var(--ms-tooltip-font-size);line-height:var(--ms-line-height-relaxed);max-width:var(--ms-tooltip-max-width);word-wrap:break-word;white-space:pre-wrap;box-shadow:var(--ms-tooltip-shadow);pointer-events:none}.ms__badge-tooltip--visible{opacity:1;visibility:visible}.ms__option-tooltip{position:fixed;z-index:var(--ms-option-tooltip-z-index);opacity:0;visibility:hidden;transition:opacity var(--ms-transition-normal) ease,visibility var(--ms-transition-normal) ease;background:var(--ms-option-tooltip-bg);color:var(--ms-option-tooltip-text-color);padding:var(--ms-option-tooltip-padding);border-radius:var(--ms-option-tooltip-border-radius);font-size:var(--ms-option-tooltip-font-size);line-height:var(--ms-line-height-relaxed);max-width:var(--ms-option-tooltip-max-width);word-wrap:break-word;white-space:pre-wrap;box-shadow:var(--ms-option-tooltip-shadow);pointer-events:none}.ms__option-tooltip--visible{opacity:1;visibility:visible}.ms__selected-popover{display:none;position:fixed;z-index:var(--ms-z-index-popover);background:var(--ms-selected-popover-bg);border:var(--ms-selected-popover-border);border-radius:var(--ms-selected-popover-border-radius);box-shadow:var(--ms-selected-popover-box-shadow);width:var(--ms-selected-popover-width);max-height:var(--ms-selected-popover-max-height);overflow:hidden}.ms__selected-popover--visible{display:flex;flex-direction:column}.ms__selected-popover--virtual{display:block;overflow:visible;max-height:none}.ms__selected-popover-header{display:flex;align-items:center;justify-content:space-between;padding:var(--ms-selected-popover-header-padding);background:var(--ms-selected-popover-header-bg);border-bottom:var(--ms-selected-popover-header-border-bottom);font-size:var(--ms-selected-popover-header-font-size);font-weight:var(--ms-selected-popover-header-font-weight);color:var(--ms-selected-popover-header-color)}.ms__selected-popover-close{display:flex;align-items:center;justify-content:center;width:var(--ms-popover-close-size);height:var(--ms-popover-close-size);padding:0;border:none;background:var(--ms-selected-popover-close-bg);color:var(--ms-selected-popover-close-color);font-size:var(--ms-selected-popover-close-font-size);line-height:var(--ms-line-height-none);cursor:pointer;border-radius:var(--ms-selected-popover-close-border-radius);transition:all var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__selected-popover-close:hover{background:var(--ms-selected-popover-close-bg-hover);color:var(--ms-selected-popover-close-color-hover)}.ms__selected-popover-close:before{content:"";display:block;width:var(--ms-selected-popover-close-icon-size);height:var(--ms-selected-popover-close-icon-size);background-color:currentColor;-webkit-mask:var(--ms-icon-remove) center / contain no-repeat;mask:var(--ms-icon-remove) center / contain no-repeat}.ms__selected-popover-body{display:flex;flex-direction:column;gap:var(--ms-selected-popover-body-gap);padding:var(--ms-selected-popover-body-padding);overflow-y:auto;max-height:var(--ms-selected-popover-body-max-height);scrollbar-width:thin;scrollbar-color:var(--ms-scrollbar-thumb-bg) var(--ms-scrollbar-track-bg)}.ms__selected-popover-body::-webkit-scrollbar{width:var(--ms-scrollbar-width)}.ms__selected-popover-body::-webkit-scrollbar-track{background:var(--ms-scrollbar-track-bg)}.ms__selected-popover-body::-webkit-scrollbar-thumb{background:var(--ms-scrollbar-thumb-bg);border-radius:var(--ms-scrollbar-thumb-border-radius)}.ms__selected-popover-body::-webkit-scrollbar-thumb:hover{background:var(--ms-scrollbar-thumb-bg-hover)}.ms__selected-popover-body .ms__badge{width:100%;min-height:fit-content;line-height:var(--ms-line-height-relaxed)}.ms__selected-popover-body .ms__badge-text{flex:1;min-width:0;white-space:normal;word-wrap:break-word}.ms__selected-popover-body--virtual{display:block;max-height:none;padding:0}.ms__selected-popover-body--virtual .ms__badge{height:var(--ms-badge-height-virtual, 36px);min-height:var(--ms-badge-height-virtual, 36px);max-height:var(--ms-badge-height-virtual, 36px);margin-bottom:var(--ms-selected-popover-body-gap);overflow:hidden;box-sizing:border-box}.ms__selected-popover-body--virtual .ms__badge-text{white-space:nowrap;overflow:hidden;text-overflow:ellipsis}}@layer component{.ms--disabled .ms__input{opacity:var(--ms-disabled-input-opacity);cursor:not-allowed;background:var(--ms-input-bg-disabled)}.ms--disabled .ms__toggle{opacity:var(--ms-disabled-input-opacity)}.ms--no-checkboxes .ms__option{gap:0;padding-left:var(--ms-option-padding-h)}.ms--no-checkboxes .ms__option-content{padding-left:0}}@layer component;@layer component{.ms__badges{display:flex;flex-wrap:wrap;gap:var(--ms-badges-gap);padding:0}.ms__badges:empty{display:none}.ms__badges--bottom{margin-top:var(--ms-badges-margin-bottom)}.ms__badges--top{margin-bottom:var(--ms-badges-margin-top);order:var(--ms-order-first)}.ms__badges--left{order:var(--ms-order-first);margin-right:var(--ms-badges-margin-left);justify-content:flex-end}.ms__badges--right{margin-left:var(--ms-badges-margin-right);justify-content:flex-start}.ms__badge{display:inline-flex;align-items:center;height:var(--ms-badge-height);font-size:var(--ms-badge-font-size);font-weight:var(--ms-badge-font-weight);line-height:var(--ms-line-height-none);border-radius:var(--ms-badge-border-radius);overflow:hidden;max-width:100%}.ms__badge-text{display:flex;align-items:center;box-sizing:border-box;height:100%;padding:var(--ms-badge-text-padding);background:var(--ms-badge-text-bg);color:var(--ms-badge-text-color);border:var(--ms-badge-text-border);border-right:none;border-radius:var(--ms-badge-border-radius) 0 0 var(--ms-badge-border-radius);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;transition:background-color var(--ms-transition-normal) ease,color var(--ms-transition-normal) ease}.ms__badge:hover .ms__badge-text{background:var(--ms-badge-text-bg-hover, var(--ms-badge-text-bg));color:var(--ms-badge-text-color-hover, var(--ms-badge-text-color))}.ms__badge-remove{display:flex;align-items:center;justify-content:center;box-sizing:border-box;font-family:inherit;width:var(--ms-badge-remove-width);height:100%;flex-shrink:0;background:var(--ms-badge-remove-bg);color:var(--ms-badge-remove-color);border:var(--ms-badge-remove-border);border-left:none;border-radius:0 var(--ms-badge-border-radius) var(--ms-badge-border-radius) 0;cursor:pointer;transition:background-color var(--ms-transition-normal) ease;font-size:var(--ms-badge-remove-font-size)}.ms__badge-remove:hover{background:var(--ms-badge-remove-bg-hover)}.ms__badge-remove:focus{outline:none}.ms__badge-remove:focus-visible{outline:none;box-shadow:var(--ms-badge-remove-box-shadow-focus)}.ms__badge-remove:before{content:"";display:block;width:var(--ms-badge-remove-icon-size);height:var(--ms-badge-remove-icon-size);background-color:currentColor;-webkit-mask:var(--ms-icon-remove) center / contain no-repeat;mask:var(--ms-icon-remove) center / contain no-repeat}.ms__badge--counter{cursor:pointer}.ms__badge--counter .ms__badge-text{background:var(--ms-badge-counter-text-bg);color:var(--ms-badge-counter-text-color);border:var(--ms-badge-counter-border);border-right:none}.ms__badge--counter .ms__badge-remove{background:var(--ms-badge-counter-remove-bg);color:var(--ms-badge-counter-remove-color);border:var(--ms-badge-counter-border);border-left:none}.ms__badge--counter .ms__badge-remove:hover{background:var(--ms-badge-counter-remove-bg-hover)}.ms__badge--more,.ms__badge[data-action=show-selected]{cursor:pointer}}@layer component{.ms__count-display{display:flex;align-items:center}.ms__count-display:empty{display:none}.ms__count-display--bottom{margin-top:var(--ms-count-display-margin-bottom)}.ms__count-display--top{margin-bottom:var(--ms-count-display-margin-top);order:var(--ms-order-first)}.ms__count-display--left{order:var(--ms-order-first);margin-right:var(--ms-count-display-margin-left);justify-content:flex-start}.ms__count-display--right{margin-left:var(--ms-count-display-margin-right);justify-content:flex-end}.ms__counter-wrapper{display:inline-flex;align-items:center;gap:var(--ms-counter-wrapper-gap);background:var(--ms-counter-wrapper-bg);border:var(--ms-counter-wrapper-border);border-radius:var(--ms-counter-wrapper-border-radius);padding:var(--ms-counter-wrapper-padding);transition:all var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__counter-wrapper:hover{background:var(--ms-counter-wrapper-bg-hover);border-color:var(--ms-counter-wrapper-border-color-hover)}.ms__count-text{display:inline-flex;align-items:center;background:var(--ms-count-text-bg);border:var(--ms-count-text-border);padding:0;font-size:var(--ms-count-text-font-size);color:var(--ms-count-text-color);cursor:pointer;transition:color var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__count-clear{flex-shrink:0;display:flex;align-items:center;justify-content:center;width:var(--ms-count-clear-size);height:var(--ms-count-clear-size);padding:0;border:none;background:var(--ms-count-clear-bg);color:var(--ms-count-clear-color);font-size:var(--ms-count-clear-font-size);line-height:var(--ms-line-height-none);cursor:pointer;border-radius:var(--ms-count-clear-border-radius);transition:all var(--ms-transition-fast) var(--ms-easing-snappy)}.ms__count-clear:hover{background:var(--ms-count-clear-bg-hover);color:var(--ms-count-clear-color-hover)}.ms__count-clear:before{content:"";display:block;width:var(--ms-count-clear-icon-size);height:var(--ms-count-clear-icon-size);background-color:currentColor;-webkit-mask:var(--ms-icon-clear) center / contain no-repeat;mask:var(--ms-icon-clear) center / contain no-repeat}}@layer component{.ms__debug-info{margin-top:calc(.4 * var(--ms-rem));padding:calc(.4 * var(--ms-rem));background-color:var(--ms-debug-bg);border:1px solid var(--ms-debug-border-color);border-radius:var(--ms-debug-border-radius);font-size:calc(1.2 * var(--ms-rem));color:var(--ms-debug-text-color)}.ms__debug-info details summary{cursor:pointer;font-weight:600;color:var(--ms-debug-summary-color);-webkit-user-select:none;user-select:none;padding:calc(.4 * var(--ms-rem));border-radius:var(--ms-debug-summary-border-radius)}.ms__debug-info details summary:hover{background-color:var(--ms-debug-summary-bg-hover)}.ms__debug-info details summary:focus{outline:2px solid var(--ms-debug-summary-outline-color);outline-offset:2px}.ms__debug-info .ms__debug-stats{display:flex;flex-direction:column;gap:calc(.4 * var(--ms-rem));margin-top:calc(.4 * var(--ms-rem));padding:calc(.4 * var(--ms-rem));background-color:var(--ms-debug-stats-bg);border-radius:var(--ms-debug-stats-border-radius)}.ms__debug-info .ms__debug-stats span{display:flex;justify-content:space-between;padding:2px 4px;font-family:monospace;font-size:calc(1 * var(--ms-rem))}.ms__debug-info .ms__debug-stats span:before{content:"•";margin-right:calc(.4 * var(--ms-rem));color:var(--ms-debug-bullet-color)}}@layer component{.ms__options{padding:var(--ms-options-padding);scrollbar-width:thin;scrollbar-color:var(--ms-scrollbar-thumb-bg) var(--ms-scrollbar-track-bg)}.ms__options::-webkit-scrollbar{width:var(--ms-scrollbar-width)}.ms__options::-webkit-scrollbar-track{background:var(--ms-scrollbar-track-bg)}.ms__options::-webkit-scrollbar-thumb{background:var(--ms-scrollbar-thumb-bg);border-radius:var(--ms-scrollbar-thumb-border-radius)}.ms__options::-webkit-scrollbar-thumb:hover{background:var(--ms-scrollbar-thumb-bg-hover)}.ms__options--virtual .ms__option{height:var(--ms-option-height, 50px);min-height:var(--ms-option-height, 50px);max-height:var(--ms-option-height, 50px);overflow:hidden;box-sizing:border-box}.ms__group+.ms__group{border-top:var(--ms-group-border-top);margin-top:var(--ms-group-margin-top);padding-top:var(--ms-group-padding-top)}.ms__group-label{padding:var(--ms-group-label-padding);font-size:var(--ms-group-label-font-size);font-weight:var(--ms-group-label-font-weight);color:var(--ms-group-label-color);text-transform:var(--ms-group-label-transform);letter-spacing:var(--ms-group-label-letter-spacing)}.ms__option{display:flex;align-items:var(--ms-checkbox-align, center);gap:var(--ms-option-gap);padding:var(--ms-option-padding);color:var(--ms-option-text-color);background:var(--ms-option-bg);cursor:pointer}.ms__option:hover{background:var(--ms-option-bg-hover);color:var(--ms-option-color-hover, inherit)}.ms__option--focused{background:var(--ms-option-bg-focused);color:var(--ms-option-color-focused, inherit);outline:var(--ms-option-outline-focused);outline-offset:var(--ms-option-focus-outline-offset)}.ms__option--matched{background:var(--ms-option-bg-matched);color:var(--ms-option-color-matched, inherit);border-left:var(--ms-option-border-matched)}.ms__option--selected{background:var(--ms-option-bg-selected)}.ms__option--selected:hover{background:var(--ms-option-bg-selected-hover, var(--ms-option-bg-selected))}.ms__option--disabled{opacity:var(--ms-disabled-opacity);cursor:not-allowed;background:var(--ms-option-disabled-bg)}.ms__option--disabled:hover{background:var(--ms-option-disabled-bg)}.ms__option--focused:hover{background:var(--ms-option-bg-focused-hover);color:var(--ms-option-color-focused-hover, var(--ms-option-color-focused, var(--ms-option-text-color)))}.ms__option--matched:hover{background:var(--ms-option-bg-matched-hover);color:var(--ms-option-color-matched-hover, var(--ms-option-color-matched, var(--ms-option-text-color)))}.ms__option--selected.ms__option--focused{background:var(--ms-option-bg-selected-focused);outline:var(--ms-option-outline-focused);outline-offset:var(--ms-option-focus-outline-offset)}.ms__option--selected.ms__option--matched{background:var(--ms-option-bg-selected-matched);border-left:var(--ms-option-border-matched)}.ms__option--disabled.ms__option--selected{background:var(--ms-option-bg-disabled-selected)}.ms__option--disabled.ms__option--focused{outline:none}.ms__option[data-checkbox-align=top]{--ms-checkbox-align: flex-start}.ms__option[data-checkbox-align=bottom]{--ms-checkbox-align: flex-end}.ms__checkbox{appearance:none;-webkit-appearance:none;-moz-appearance:none;flex-shrink:0;position:relative;margin-top:var(--ms-checkbox-margin-top);margin-right:var(--ms-checkbox-margin-right);margin-bottom:var(--ms-checkbox-margin-bottom);margin-left:var(--ms-checkbox-margin-left);width:var(--ms-checkbox-size);height:var(--ms-checkbox-size);transform:scale(var(--ms-checkbox-scale));transform-origin:top left;cursor:pointer;background:var(--ms-checkbox-bg);border:var(--ms-checkbox-border);border-radius:var(--ms-checkbox-border-radius);transition:background-color .15s ease,border-color .15s ease}.ms__checkbox:after{content:"";position:absolute;display:none;left:50%;top:40%;width:30%;height:55%;transform:translate(-50%,-50%) rotate(45deg);border:solid var(--ms-checkbox-checkmark-color);border-width:0 2px 2px 0}.ms__checkbox:hover:not(:disabled){border-color:var(--ms-checkbox-hover-border-color)}.ms__checkbox:checked{background:var(--ms-checkbox-checked-bg);border:var(--ms-checkbox-checked-border)}.ms__checkbox:checked:after{display:block}.ms__checkbox:checked:hover:not(:disabled){background:var(--ms-checkbox-checked-bg-hover);border-color:var(--ms-checkbox-checked-border-color-hover)}.ms__checkbox:focus-visible{outline:2px solid var(--ms-checkbox-checked-bg);outline-offset:2px}.ms__checkbox:disabled{cursor:not-allowed;background:var(--ms-checkbox-disabled-bg);border:var(--ms-checkbox-disabled-border);opacity:.6}.ms__checkbox:disabled:checked{background:var(--ms-checkbox-disabled-bg)}.ms__option--disabled .ms__checkbox{cursor:not-allowed}.ms__option-content{flex:1;display:flex;align-items:center;gap:var(--ms-option-content-gap);min-width:0}.ms__option-icon{flex-shrink:0;width:var(--ms-option-icon-size);height:var(--ms-option-icon-size);display:flex;align-items:center;justify-content:center;font-size:var(--ms-option-icon-font-size)}.ms__option-icon svg{width:100%;height:100%;fill:currentColor}.ms__option-text{flex:1;min-width:0}.ms__option-title{font-size:var(--ms-option-title-font-size);color:var(--ms-option-title-color);line-height:var(--ms-line-height-relaxed)}.ms__option:hover .ms__option-title{color:var(--ms-option-title-color-hover, var(--ms-option-title-color))}.ms__option--selected .ms__option-title{color:var(--ms-option-title-color-selected, var(--ms-option-title-color))}.ms__option--selected:hover .ms__option-title{color:var(--ms-option-title-color-selected-hover, var(--ms-option-title-color-selected, var(--ms-option-title-color)))}.ms__option-title mark{background:var(--ms-option-mark-bg);color:var(--ms-option-mark-color);font-weight:var(--ms-option-mark-font-weight)}.ms__option-subtitle{margin-top:var(--ms-option-subtitle-margin-top);font-size:var(--ms-option-subtitle-font-size);color:var(--ms-option-subtitle-color);line-height:var(--ms-option-subtitle-line-height)}.ms__option:hover .ms__option-subtitle{color:var(--ms-option-subtitle-color-hover, var(--ms-option-subtitle-color))}.ms__option--selected .ms__option-subtitle{color:var(--ms-option-subtitle-color-selected, var(--ms-option-subtitle-color))}.ms__option--selected:hover .ms__option-subtitle{color:var(--ms-option-subtitle-color-selected-hover, var(--ms-option-subtitle-color-selected, var(--ms-option-subtitle-color)))}.ms__empty{display:flex;align-items:center;justify-content:center;min-height:var(--ms-state-min-height);padding:var(--ms-empty-padding);text-align:center;font-size:var(--ms-empty-font-size);color:var(--ms-empty-color)}.ms__loader{display:flex;flex-direction:column;align-items:center;justify-content:center;min-height:var(--ms-state-min-height);padding:var(--ms-loader-padding);gap:var(--ms-loader-gap)}.ms__loading-text{font-size:var(--ms-loading-text-font-size);color:var(--ms-loading-color)}}@layer component{.ms--rtl .ms__input-wrapper{direction:rtl}.ms--rtl .ms__input{text-align:right;padding-left:var(--ms-input-padding-right);padding-right:var(--ms-input-padding-h)}.ms--rtl .ms__toggle{left:var(--ms-toggle-right)!important;right:auto!important}.ms--rtl .ms__counter{left:var(--ms-counter-offset)!important;right:auto!important}.ms--rtl .ms__dropdown{direction:rtl;text-align:right}.ms--rtl .ms__option{flex-direction:row-reverse}.ms--rtl .ms__checkbox{margin-left:var(--ms-spacing-sm);margin-right:0}.ms--rtl .ms__option-content{text-align:right}.ms--rtl .ms__option-icon{margin-left:var(--ms-spacing-xs);margin-right:0}.ms--rtl .ms__badges{direction:rtl}.ms--rtl .ms__badges--right{margin-left:0;margin-right:var(--ms-badges-margin-right)}.ms--rtl .ms__badges--left{margin-right:0;margin-left:var(--ms-badges-margin-left)}.ms--rtl .ms__badge{flex-direction:row-reverse}.ms--rtl .ms__badge-remove{border-radius:var(--ms-badge-border-radius) 0 0 var(--ms-badge-border-radius);border-left:var(--ms-badge-remove-border);border-right:none}.ms--rtl .ms__badge-text{border-radius:0 var(--ms-badge-border-radius) var(--ms-badge-border-radius) 0;border-right:var(--ms-badge-text-border);border-left:none}.ms--rtl .ms__count-display{direction:rtl}.ms--rtl .ms__count-display--right{margin-left:0;margin-right:var(--ms-count-display-margin-right)}.ms--rtl .ms__count-display--left{margin-right:0;margin-left:var(--ms-count-display-margin-left)}.ms--rtl .ms__counter-wrapper{flex-direction:row-reverse}.ms--rtl .ms__selected-popover{direction:rtl;text-align:right}.ms--rtl .ms__actions{direction:rtl}.ms--rtl .ms__group-label,.ms--rtl .ms__empty{text-align:right}.ms--rtl .ms__hint{direction:rtl;text-align:right}}@layer overrides{:host-context([data-theme="dark"]),:host-context([data-bs-theme="dark"]),:host-context(.dark){color-scheme:dark}:host-context([data-theme="light"]),:host-context([data-bs-theme="light"]),:host-context(.light){color-scheme:light}:host([data-theme="dark"]){color-scheme:dark}:host([data-theme="light"]){color-scheme:light}}`, Ss = typeof HTMLElement < "u" ? HTMLElement : class {
}, Ce = [
  // Strings
  { attr: "search-hint", key: "searchHint", parser: "string-or-undefined" },
  { attr: "search-placeholder", key: "searchPlaceholder", parser: "string", default: "Search..." },
  { attr: "select-placeholder", key: "selectPlaceholder", parser: "string", default: "Pick an option..." },
  { attr: "no-data-placeholder", key: "noDataPlaceholder", parser: "string-or-undefined" },
  { attr: "dropdown-min-width", key: "dropdownMinWidth", parser: "string-or-undefined" },
  { attr: "dropdown-max-width", key: "dropdownMaxWidth", parser: "string-or-undefined" },
  { attr: "max-height", key: "maxHeight", parser: "string", default: "20rem" },
  { attr: "empty-message", key: "emptyMessage", parser: "string", default: "No results found" },
  { attr: "loading-message", key: "loadingMessage", parser: "string", default: "Loading..." },
  { attr: "remove-button-tooltip-text", key: "removeButtonTooltipText", parser: "string-or-undefined" },
  { attr: "name", key: "formFieldId", parser: "string-or-undefined" },
  // Member properties (have programmatic fallback applied after parse)
  { attr: "value-member", key: "valueMember", parser: "string-or-undefined" },
  { attr: "display-value-member", key: "displayValueMember", parser: "string-or-undefined" },
  { attr: "search-value-member", key: "searchValueMember", parser: "string-or-undefined" },
  { attr: "icon-member", key: "iconMember", parser: "string-or-undefined" },
  { attr: "subtitle-member", key: "subtitleMember", parser: "string-or-undefined" },
  { attr: "group-member", key: "groupMember", parser: "string-or-undefined" },
  { attr: "disabled-member", key: "disabledMember", parser: "string-or-undefined" },
  // Enums
  {
    attr: "badges-display-mode",
    key: "badgesDisplayMode",
    parser: "enum",
    enumValues: ["badges", "count", "compact", "partial", "none"],
    default: "badges"
  },
  {
    attr: "badges-position",
    key: "badgesPosition",
    parser: "enum",
    enumValues: ["top", "bottom", "left", "right"],
    default: "bottom"
  },
  {
    attr: "badges-threshold-mode",
    key: "badgesThresholdMode",
    parser: "enum",
    enumValues: ["count", "partial"],
    default: "count"
  },
  {
    attr: "search-input-mode",
    key: "searchInputMode",
    parser: "enum",
    enumValues: ["normal", "readonly", "hidden"],
    default: "normal"
  },
  {
    attr: "search-mode",
    key: "searchMode",
    parser: "enum",
    enumValues: ["filter", "navigate"],
    default: "filter"
  },
  {
    attr: "actions-layout",
    key: "actionsLayout",
    parser: "enum",
    enumValues: ["nowrap", "wrap"],
    default: "nowrap"
  },
  {
    attr: "actions-position",
    key: "actionsPosition",
    parser: "enum",
    enumValues: ["top", "bottom"],
    default: "top"
  },
  {
    attr: "actions-align",
    key: "actionsAlign",
    parser: "enum",
    enumValues: ["stretch", "left", "right", "center", "space-between"],
    default: "stretch"
  },
  {
    attr: "checkbox-align",
    key: "checkboxAlign",
    parser: "enum",
    enumValues: ["top", "center", "bottom"],
    default: "center"
  },
  {
    attr: "value-format",
    key: "valueFormat",
    parser: "enum",
    enumValues: ["json", "csv", "array"],
    default: "json"
  },
  {
    attr: "badge-tooltip-placement",
    key: "badgeTooltipPlacement",
    parser: "enum",
    enumValues: ["top", "top-start", "top-end", "bottom", "bottom-start", "bottom-end", "left", "left-start", "left-end", "right", "right-start", "right-end"],
    default: "top"
  },
  {
    attr: "option-tooltip-placement",
    key: "optionTooltipPlacement",
    parser: "enum",
    enumValues: ["top", "top-start", "top-end", "bottom", "bottom-start", "bottom-end", "left", "left-start", "left-end", "right", "right-start", "right-end"],
    default: "top-start"
  },
  // Numbers
  { attr: "badges-threshold", key: "badgesThreshold", parser: "int" },
  { attr: "badges-max-visible", key: "badgesMaxVisible", parser: "int" },
  { attr: "min-search-length", key: "minSearchLength", parser: "int", default: 0 },
  { attr: "search-debounce", key: "searchDebounce", parser: "int", default: 0 },
  { attr: "virtual-scroll-threshold", key: "virtualScrollThreshold", parser: "int", default: 100 },
  { attr: "option-height", key: "optionHeight", parser: "int", default: 50 },
  { attr: "badge-height", key: "badgeHeight", parser: "int", default: 36 },
  { attr: "virtual-scroll-buffer", key: "virtualScrollBuffer", parser: "int", default: 10 },
  { attr: "badge-tooltip-delay", key: "badgeTooltipDelay", parser: "int", default: 100 },
  { attr: "badge-tooltip-offset", key: "badgeTooltipOffset", parser: "int", default: 8 },
  { attr: "option-tooltip-delay", key: "optionTooltipDelay", parser: "int" },
  { attr: "option-tooltip-offset", key: "optionTooltipOffset", parser: "int" },
  // Booleans (default true: presence/empty = true; only 'false' negates)
  { attr: "multiple", key: "isMultipleEnabled", parser: "bool-default-true" },
  { attr: "allow-groups", key: "isGroupsAllowed", parser: "bool-default-true" },
  { attr: "show-checkboxes", key: "isCheckboxesShown", parser: "bool-default-true" },
  { attr: "sticky-actions", key: "isActionsSticky", parser: "bool-default-true" },
  { attr: "lock-placement", key: "isPlacementLocked", parser: "bool-default-true" },
  { attr: "enable-search", key: "isSearchEnabled", parser: "bool-default-true" },
  { attr: "keep-options-on-search", key: "isKeepOptionsOnSearch", parser: "bool-default-true" },
  { attr: "should-keep-search-on-close", key: "shouldKeepSearchOnClose", parser: "bool-default-true" },
  // Booleans (default false: only 'true' enables)
  { attr: "close-on-select", key: "isCloseOnSelect", parser: "bool-default-false" },
  { attr: "allow-add-new", key: "isAddNewAllowed", parser: "bool-default-false" },
  { attr: "show-counter", key: "isCounterShown", parser: "bool-default-false" },
  { attr: "enable-virtual-scroll", key: "isVirtualScrollEnabled", parser: "bool-default-false" },
  { attr: "enable-badge-tooltips", key: "isBadgeTooltipsEnabled", parser: "bool-default-false" },
  { attr: "enable-option-tooltips", key: "isOptionTooltipsEnabled", parser: "bool-default-false" },
  { attr: "option-tooltip-follow-cursor", key: "isOptionTooltipFollowCursor", parser: "bool-default-false" }
], Ts = new Map(Ce.map((o) => [o.attr, o])), je = [
  { key: "valueMember", field: "_valueMember" },
  { key: "displayValueMember", field: "_displayValueMember" },
  { key: "searchValueMember", field: "_searchValueMember" },
  { key: "iconMember", field: "_iconMember" },
  { key: "subtitleMember", field: "_subtitleMember" },
  { key: "groupMember", field: "_groupMember" },
  { key: "disabledMember", field: "_disabledMember" }
], Os = [
  { key: "valueMember", member: "value" },
  { key: "displayValueMember", member: "label" },
  { key: "groupMember", member: "group" },
  { key: "iconMember", member: "icon" },
  { key: "subtitleMember", member: "subtitle" },
  { key: "disabledMember", member: "disabled" }
];
function Ue(o, e) {
  if (e === null || e === "")
    switch (o.parser) {
      case "bool-default-true":
        return !0;
      case "bool-default-false":
        return !1;
      default:
        return o.default;
    }
  switch (o.parser) {
    case "string":
    case "string-or-undefined":
      return e;
    case "enum":
      return o.enumValues.includes(e) ? e : o.default;
    case "int": {
      const t = parseInt(e);
      return isNaN(t) ? o.default : t;
    }
    case "bool-default-true":
      return e !== "false";
    case "bool-default-false":
      return e === "true";
  }
}
const Se = /* @__PURE__ */ new Set();
function ct() {
  return Array.from(Se);
}
class Me extends Ss {
  constructor() {
    super();
    d(this, "picker");
    d(this, "containerElement");
    d(this, "shadow");
    d(this, "internals");
    // Properties for complex data (not attributes)
    d(this, "_options");
    d(this, "_hasDeclarativeOptions", !1);
    // Member/Callback properties
    d(this, "_valueMember");
    d(this, "_getValueCallback");
    d(this, "_displayValueMember");
    d(this, "_getDisplayValueCallback");
    d(this, "_getBadgeDisplayCallback");
    d(this, "_getBadgeClassCallback");
    d(this, "_customStylesCallback");
    d(this, "_searchValueMember");
    d(this, "_getSearchValueCallback");
    d(this, "_iconMember");
    d(this, "_getIconCallback");
    d(this, "_subtitleMember");
    d(this, "_getSubtitleCallback");
    d(this, "_groupMember");
    d(this, "_getGroupCallback");
    d(this, "_renderGroupLabelContentCallback");
    d(this, "_disabledMember");
    d(this, "_getDisabledCallback");
    // Value formatting callbacks
    d(this, "_getValueFormatCallback");
    // Tooltip callbacks
    d(this, "_getBadgeTooltipCallback");
    d(this, "_getOptionTooltipCallback");
    d(this, "_getRemoveButtonTooltipCallback");
    // Custom rendering callbacks
    d(this, "_renderOptionContentCallback");
    d(this, "_renderBadgeContentCallback");
    d(this, "_renderSelectedItemContentCallback");
    d(this, "_getSelectedItemClassCallback");
    d(this, "_renderSelectedContentCallback");
    // Count badge callback
    d(this, "_getCounterCallback");
    // Action buttons
    d(this, "_actionButtons");
    // Batch-update state (setAttributes): collects per-attribute changes so a group of
    // attribute writes applies as a single in-place update instead of one re-render each.
    d(this, "_batchDepth", 0);
    d(this, "_batchPartial", {});
    d(this, "_batchNeedsReinit", !1);
    // Event callbacks
    d(this, "_beforeSearchCallback");
    d(this, "_beforeSelectCallback");
    d(this, "_beforeDeselectCallback");
    d(this, "_searchCallback");
    d(this, "_addNewCallback");
    d(this, "_onSelect");
    d(this, "_onDeselect");
    d(this, "_onChange");
    d(this, "_declarativeSelectedValues");
    if (this.shadow = this.attachShadow({ mode: "open" }), typeof this.attachInternals == "function")
      try {
        this.internals = this.attachInternals();
      } catch {
      }
    const t = document.createElement("style");
    t.textContent = Cs, this.shadow.appendChild(t), requestAnimationFrame(() => {
      this.setAttribute("data-ready", "");
    });
  }
  static get observedAttributes() {
    return [
      ...Ce.map((t) => t.attr),
      // Out-of-table attributes (handled by special-case logic in attributeChangedCallback)
      "initial-values",
      "show-debug-info"
    ];
  }
  /**
   * Called by the browser when the surrounding <form> is reset. Clears the
   * picker's selection so the multiselect actually participates in the
   * standard reset lifecycle. (Before form-association, reset was a no-op
   * because the hidden inputs were re-stamped from internal state on every
   * render.)
   */
  formResetCallback() {
    var t;
    (t = this.picker) == null || t.clearAll();
  }
  connectedCallback() {
    Se.add(this), this.render();
    const t = this.parseDeclarativeOptions();
    t && (this._options && this._options.length > 0 && x.warn("[MultiSelectElement] Both declarative <option> elements and programmatic .options detected. Using declarative options."), this._options = t, this._hasDeclarativeOptions = !0), this.initializePicker();
  }
  disconnectedCallback() {
    Se.delete(this), this.picker && this.picker.destroy();
  }
  attributeChangedCallback(t, s, i) {
    var n;
    if (s === i || !this.picker || t === "initial-values") return;
    if (t === "show-debug-info") {
      const a = this.shadow.querySelector(".ms__debug-info");
      a && a.remove(), i === "true" && this.renderDebugInfo();
      return;
    }
    const r = Ts.get(t);
    if (r) {
      const a = Ue(r, i), l = (n = je.find((u) => u.key === r.key)) == null ? void 0 : n.field, h = a === void 0 && l ? this[l] : a;
      if (this._batchDepth > 0) {
        this._batchPartial[r.key] = h;
        return;
      }
      const c = { [r.key]: h };
      if (this.picker.updateOptions(c)) return;
    }
    if (this._batchDepth > 0) {
      this._batchNeedsReinit = !0;
      return;
    }
    this.reinitialize();
  }
  /**
   * Set several attributes in one in-place update — a single re-render instead of one per
   * attribute (and a single reinit at most if any change is structural). Keys are attribute
   * names in kebab-case, exactly as `setAttribute`. A value of `null`/`undefined`/`false`
   * removes the attribute; `true` sets it to an empty string; anything else is stringified.
   *
   * @example
   *   el.setAttributes({
   *     'search-placeholder': t('search'),
   *     'select-placeholder': t('pick'),
   *     'no-data-placeholder': t('noData'),
   *   });
   */
  setAttributes(t) {
    this._batchDepth++;
    try {
      for (const [r, n] of Object.entries(t))
        n == null || n === !1 ? this.removeAttribute(r) : this.setAttribute(r, n === !0 ? "" : String(n));
    } finally {
      this._batchDepth--;
    }
    if (this._batchDepth > 0) return;
    const s = this._batchPartial, i = this._batchNeedsReinit;
    if (this._batchPartial = {}, this._batchNeedsReinit = !1, !!this.picker) {
      if (i) {
        this.reinitialize();
        return;
      }
      Object.keys(s).length > 0 && (this.picker.updateOptions(s) || this.reinitialize());
    }
  }
  render() {
    this.containerElement = document.createElement("div"), this.containerElement.setAttribute("data-multiselect", ""), this.className && (this.containerElement.className = this.className), this.shadow.appendChild(this.containerElement), this.getAttribute("show-debug-info") === "true" && this.renderDebugInfo();
  }
  renderDebugInfo() {
    const t = this.shadow.querySelector(".ms__debug-info");
    t && t.remove();
    const s = document.createElement("div");
    s.className = "ms__debug-info";
    const i = document.createElement("details"), r = document.createElement("summary");
    r.textContent = "Debug Info";
    const n = document.createElement("div");
    n.className = "ms__debug-stats", i.appendChild(r), i.appendChild(n), s.appendChild(i), this.shadow.appendChild(s), this.updateDebugInfo();
  }
  updateDebugInfo() {
    var m, b;
    const t = this.shadow.querySelector(".ms__debug-stats");
    if (!t || !this.picker) return;
    const s = "1.12.0-rc05", i = ct().length, n = this.picker.getSelected().length, a = ((m = this._options) == null ? void 0 : m.length) || 0, l = this.picker, h = l.isOpen || !1, c = l.searchTerm || "", p = l.isLoading || !1, u = ((b = l.filteredOptions) == null ? void 0 : b.length) || 0;
    t.innerHTML = `
            <span>Version: ${s}</span>
            <span>Total Instances: ${i}</span>
            <span>Options: ${a}</span>
            <span>Filtered: ${u}</span>
            <span>Selected: ${n}</span>
            <span>Dropdown: ${h ? "Open" : "Closed"}</span>
            <span>Search: ${c || "none"}</span>
            <span>Loading: ${p ? "Yes" : "No"}</span>
        `, setTimeout(() => {
      this.getAttribute("show-debug-info") === "true" && this.updateDebugInfo();
    }, 500);
  }
  /**
   * Parse declarative <option> and <optgroup> elements from Light DOM
   * Returns array of options in the format expected by the picker
   */
  parseDeclarativeOptions() {
    var r, n, a, l;
    const t = [], s = Array.from(this.children);
    if (s.length === 0)
      return null;
    let i = !1;
    for (const h of s)
      if (h.tagName === "OPTION") {
        const c = h, p = {
          value: c.value || ((r = c.textContent) == null ? void 0 : r.trim()) || "",
          label: ((n = c.textContent) == null ? void 0 : n.trim()) || c.value || ""
        };
        c.hasAttribute("selected") && (this._declarativeSelectedValues || (this._declarativeSelectedValues = []), this._declarativeSelectedValues.push(p.value)), c.hasAttribute("disabled") && (p.disabled = !0), c.hasAttribute("data-icon") && (p.icon = c.getAttribute("data-icon")), c.hasAttribute("data-subtitle") && (p.subtitle = c.getAttribute("data-subtitle")), t.push(p), i = !0;
      } else if (h.tagName === "OPTGROUP") {
        const c = h, p = c.label || c.getAttribute("label") || "Group", u = Array.from(c.querySelectorAll("option"));
        for (const m of u) {
          const b = {
            value: m.value || ((a = m.textContent) == null ? void 0 : a.trim()) || "",
            label: ((l = m.textContent) == null ? void 0 : l.trim()) || m.value || "",
            group: p
          };
          m.hasAttribute("selected") && (this._declarativeSelectedValues || (this._declarativeSelectedValues = []), this._declarativeSelectedValues.push(b.value)), m.hasAttribute("disabled") && (b.disabled = !0), m.hasAttribute("data-icon") && (b.icon = m.getAttribute("data-icon")), m.hasAttribute("data-subtitle") && (b.subtitle = m.getAttribute("data-subtitle")), t.push(b), i = !0;
        }
      }
    return i ? (x.debug(`[MultiSelectElement] Parsed ${t.length} declarative options from Light DOM`), s.forEach((h) => {
      (h.tagName === "OPTION" || h.tagName === "OPTGROUP") && h.remove();
    }), t) : null;
  }
  /** Parse all observed attributes via ATTRIBUTE_TABLE into a partial config object. */
  parseAttributesFromTable() {
    const t = {};
    for (const s of Ce) {
      const i = Ue(s, this.getAttribute(s.attr));
      i !== void 0 && (t[s.key] = i);
    }
    return t;
  }
  initializePicker() {
    if (!this.containerElement) return;
    let t;
    const s = this.getAttribute("data-options");
    if (s && this._options === void 0)
      try {
        t = JSON.parse(s);
      } catch (n) {
        x.error("[MultiSelectElement] Failed to parse data-options:", n);
      }
    let i;
    if (this._declarativeSelectedValues && this._declarativeSelectedValues.length > 0)
      i = this._declarativeSelectedValues, x.debug(`[MultiSelectElement] Using ${i.length} declaratively selected values`);
    else {
      const n = this.getAttribute("initial-values");
      if (n)
        try {
          i = JSON.parse(n);
        } catch (a) {
          x.error("[MultiSelectElement] Failed to parse initial-values:", a);
        }
    }
    const r = this.parseAttributesFromTable();
    for (const { key: n, field: a } of je)
      r[n] === void 0 && (r[n] = this[a]);
    if (this._hasDeclarativeOptions) {
      const n = {
        valueMember: this._getValueCallback,
        displayValueMember: this._getDisplayValueCallback,
        groupMember: this._getGroupCallback,
        iconMember: this._getIconCallback,
        subtitleMember: this._getSubtitleCallback,
        disabledMember: this._getDisabledCallback
      };
      for (const { key: a, member: l } of Os)
        r[a] === void 0 && !n[a] && (r[a] = l);
    }
    if (Object.assign(r, {
      actionButtons: this._actionButtons,
      getValueCallback: this._getValueCallback,
      getDisplayValueCallback: this._getDisplayValueCallback,
      getBadgeDisplayCallback: this._getBadgeDisplayCallback,
      getBadgeClassCallback: this._getBadgeClassCallback,
      customStylesCallback: this._customStylesCallback,
      getSearchValueCallback: this._getSearchValueCallback,
      getIconCallback: this._getIconCallback,
      getSubtitleCallback: this._getSubtitleCallback,
      getGroupCallback: this._getGroupCallback,
      renderGroupLabelContentCallback: this._renderGroupLabelContentCallback,
      getDisabledCallback: this._getDisabledCallback,
      renderOptionContentCallback: this._renderOptionContentCallback,
      renderBadgeContentCallback: this._renderBadgeContentCallback,
      renderSelectedItemContentCallback: this._renderSelectedItemContentCallback,
      getSelectedItemClassCallback: this._getSelectedItemClassCallback,
      renderSelectedContentCallback: this._renderSelectedContentCallback,
      getValueFormatCallback: this._getValueFormatCallback,
      getBadgeTooltipCallback: this._getBadgeTooltipCallback,
      getOptionTooltipCallback: this._getOptionTooltipCallback,
      getRemoveButtonTooltipCallback: this._getRemoveButtonTooltipCallback,
      getCounterCallback: this._getCounterCallback || ((n, a) => a !== void 0 ? `+${a} more` : `${n} selected`),
      options: this._options ?? t,
      beforeSearchCallback: this._beforeSearchCallback,
      beforeSelectCallback: this._beforeSelectCallback,
      beforeDeselectCallback: this._beforeDeselectCallback,
      searchCallback: this._searchCallback,
      addNewCallback: this._addNewCallback,
      onSelect: (n) => {
        var a;
        this._onSelect && this._onSelect(n), this.dispatchEvent(new CustomEvent("select", {
          bubbles: !0,
          composed: !0,
          detail: {
            option: n,
            selectedOptions: (a = this.picker) == null ? void 0 : a.getSelected(),
            selectedValues: this.collectSelectedValues()
          }
        }));
      },
      onDeselect: (n) => {
        var a;
        this._onDeselect && this._onDeselect(n), this.dispatchEvent(new CustomEvent("deselect", {
          bubbles: !0,
          composed: !0,
          detail: {
            option: n,
            selectedOptions: (a = this.picker) == null ? void 0 : a.getSelected(),
            selectedValues: this.collectSelectedValues()
          }
        }));
      },
      onChange: (n) => {
        this._onChange && this._onChange(n), this.dispatchEvent(new CustomEvent("change", {
          bubbles: !0,
          composed: !0,
          detail: {
            selectedOptions: n,
            selectedValues: this.collectSelectedValues()
          }
        }));
      },
      // Pass shadow root as container for dropdown/hint/popover
      container: this.shadow,
      // Pass host element (this) for hidden inputs in light DOM
      hostElement: this
    }), i && (this.containerElement.dataset.initialValues = JSON.stringify(i)), this.picker = new xs(this.containerElement, r), this._customStylesCallback) {
      const n = this._customStylesCallback();
      if (n) {
        const a = document.createElement("style");
        a.className = "ms-custom-styles", a.textContent = n, this.shadow.insertBefore(a, this.shadow.firstChild);
      }
    }
  }
  reinitialize() {
    this.picker && (this.picker.destroy(), this.initializePicker());
  }
  /**
   * Apply a partial config update to the live picker. Falls back to a full reinit if the
   * picker can't apply the change in place (e.g. adding/removing the `searchHint` element).
   * No-op if the picker hasn't been initialized yet — the next `initializePicker` will pick
   * up the new programmatic state.
   */
  updatePicker(t) {
    this.picker && (this.picker.updateOptions(t) || this.reinitialize());
  }
  /** Normalize the picker's getValue() return into the array form expected by event detail. */
  collectSelectedValues() {
    var s;
    const t = (s = this.picker) == null ? void 0 : s.getValue();
    return t == null ? [] : Array.isArray(t) ? t : [t];
  }
  // ========================================================================
  // PUBLIC API - PROPERTIES
  // ========================================================================
  // Data options
  get options() {
    return this._options;
  }
  set options(t) {
    this._options = t, this.updatePicker({ options: t });
  }
  // Member properties (can also be set via attributes)
  set valueMember(t) {
    this._valueMember = t || void 0, t ? this.setAttribute("value-member", t) : this.removeAttribute("value-member");
  }
  get valueMember() {
    return this.getAttribute("value-member");
  }
  set displayValueMember(t) {
    this._displayValueMember = t || void 0, t ? this.setAttribute("display-value-member", t) : this.removeAttribute("display-value-member");
  }
  get displayValueMember() {
    return this.getAttribute("display-value-member");
  }
  set searchValueMember(t) {
    this._searchValueMember = t || void 0, t ? this.setAttribute("search-value-member", t) : this.removeAttribute("search-value-member");
  }
  get searchValueMember() {
    return this.getAttribute("search-value-member");
  }
  set iconMember(t) {
    this._iconMember = t || void 0, t ? this.setAttribute("icon-member", t) : this.removeAttribute("icon-member");
  }
  get iconMember() {
    return this.getAttribute("icon-member");
  }
  set subtitleMember(t) {
    this._subtitleMember = t || void 0, t ? this.setAttribute("subtitle-member", t) : this.removeAttribute("subtitle-member");
  }
  get subtitleMember() {
    return this.getAttribute("subtitle-member");
  }
  set groupMember(t) {
    this._groupMember = t || void 0, t ? this.setAttribute("group-member", t) : this.removeAttribute("group-member");
  }
  get groupMember() {
    return this.getAttribute("group-member");
  }
  set disabledMember(t) {
    this._disabledMember = t || void 0, t ? this.setAttribute("disabled-member", t) : this.removeAttribute("disabled-member");
  }
  get disabledMember() {
    return this.getAttribute("disabled-member");
  }
  // Callback properties (JavaScript only - no attributes)
  set getValueCallback(t) {
    this._getValueCallback = t, this.updatePicker({ getValueCallback: t });
  }
  get getValueCallback() {
    return this._getValueCallback;
  }
  set getDisplayValueCallback(t) {
    this._getDisplayValueCallback = t, this.updatePicker({ getDisplayValueCallback: t });
  }
  get getDisplayValueCallback() {
    return this._getDisplayValueCallback;
  }
  set getBadgeDisplayCallback(t) {
    this._getBadgeDisplayCallback = t, this.updatePicker({ getBadgeDisplayCallback: t });
  }
  get getBadgeDisplayCallback() {
    return this._getBadgeDisplayCallback;
  }
  set getBadgeClassCallback(t) {
    this._getBadgeClassCallback = t, this.updatePicker({ getBadgeClassCallback: t });
  }
  get getBadgeClassCallback() {
    return this._getBadgeClassCallback;
  }
  set customStylesCallback(t) {
    if (this._customStylesCallback = t, this.picker && t) {
      const s = t();
      if (s) {
        const i = this.shadow.querySelector("style.ms-custom-styles");
        i && i.remove();
        const r = document.createElement("style");
        r.className = "ms-custom-styles", r.textContent = s, this.shadow.appendChild(r), this.picker.renderBadges();
      }
    }
  }
  get customStylesCallback() {
    return this._customStylesCallback;
  }
  set getSearchValueCallback(t) {
    this._getSearchValueCallback = t, this.updatePicker({ getSearchValueCallback: t });
  }
  get getSearchValueCallback() {
    return this._getSearchValueCallback;
  }
  set getIconCallback(t) {
    this._getIconCallback = t, this.updatePicker({ getIconCallback: t });
  }
  get getIconCallback() {
    return this._getIconCallback;
  }
  set getSubtitleCallback(t) {
    this._getSubtitleCallback = t, this.updatePicker({ getSubtitleCallback: t });
  }
  get getSubtitleCallback() {
    return this._getSubtitleCallback;
  }
  set getGroupCallback(t) {
    this._getGroupCallback = t, this.updatePicker({ getGroupCallback: t });
  }
  get getGroupCallback() {
    return this._getGroupCallback;
  }
  set renderGroupLabelContentCallback(t) {
    this._renderGroupLabelContentCallback = t, this.updatePicker({ renderGroupLabelContentCallback: t });
  }
  get renderGroupLabelContentCallback() {
    return this._renderGroupLabelContentCallback;
  }
  set getDisabledCallback(t) {
    this._getDisabledCallback = t, this.updatePicker({ getDisabledCallback: t });
  }
  get getDisabledCallback() {
    return this._getDisabledCallback;
  }
  // Custom rendering callbacks
  set renderOptionContentCallback(t) {
    this._renderOptionContentCallback = t, this.updatePicker({ renderOptionContentCallback: t });
  }
  get renderOptionContentCallback() {
    return this._renderOptionContentCallback;
  }
  set renderBadgeContentCallback(t) {
    this._renderBadgeContentCallback = t, this.updatePicker({ renderBadgeContentCallback: t });
  }
  get renderBadgeContentCallback() {
    return this._renderBadgeContentCallback;
  }
  set renderSelectedItemContentCallback(t) {
    this._renderSelectedItemContentCallback = t, this.updatePicker({ renderSelectedItemContentCallback: t });
  }
  get renderSelectedItemContentCallback() {
    return this._renderSelectedItemContentCallback;
  }
  set getSelectedItemClassCallback(t) {
    this._getSelectedItemClassCallback = t, this.updatePicker({ getSelectedItemClassCallback: t });
  }
  get getSelectedItemClassCallback() {
    return this._getSelectedItemClassCallback;
  }
  set renderSelectedContentCallback(t) {
    this._renderSelectedContentCallback = t, this.updatePicker({ renderSelectedContentCallback: t });
  }
  get renderSelectedContentCallback() {
    return this._renderSelectedContentCallback;
  }
  // Form integration
  set name(t) {
    t ? this.setAttribute("name", t) : this.removeAttribute("name");
  }
  get name() {
    return this.getAttribute("name");
  }
  set valueFormat(t) {
    t ? this.setAttribute("value-format", t) : this.removeAttribute("value-format");
  }
  get valueFormat() {
    return this.getAttribute("value-format");
  }
  set getValueFormatCallback(t) {
    this._getValueFormatCallback = t, this.updatePicker({ getValueFormatCallback: t });
  }
  get getValueFormatCallback() {
    return this._getValueFormatCallback;
  }
  // Badges display options
  set thresholdMode(t) {
    t ? this.setAttribute("threshold-mode", t) : this.removeAttribute("threshold-mode");
  }
  get thresholdMode() {
    return this.getAttribute("threshold-mode");
  }
  set badgesMaxVisible(t) {
    t !== null ? this.setAttribute("badges-max-visible", String(t)) : this.removeAttribute("badges-max-visible");
  }
  get badgesMaxVisible() {
    const t = this.getAttribute("badges-max-visible");
    return t ? parseInt(t) : null;
  }
  // Checkbox options
  set checkboxAlign(t) {
    t ? this.setAttribute("checkbox-align", t) : this.removeAttribute("checkbox-align");
  }
  get checkboxAlign() {
    return this.getAttribute("checkbox-align");
  }
  // Tooltip options
  set enableBadgeTooltips(t) {
    t ? this.setAttribute("enable-badge-tooltips", "true") : this.removeAttribute("enable-badge-tooltips");
  }
  get enableBadgeTooltips() {
    return this.getAttribute("enable-badge-tooltips") === "true";
  }
  set enableOptionTooltips(t) {
    t ? this.setAttribute("enable-option-tooltips", "true") : this.removeAttribute("enable-option-tooltips");
  }
  get enableOptionTooltips() {
    return this.getAttribute("enable-option-tooltips") === "true";
  }
  set getOptionTooltipCallback(t) {
    this._getOptionTooltipCallback = t, this.updatePicker({ getOptionTooltipCallback: t });
  }
  get getOptionTooltipCallback() {
    return this._getOptionTooltipCallback;
  }
  set optionTooltipPlacement(t) {
    t ? this.setAttribute("option-tooltip-placement", t) : this.removeAttribute("option-tooltip-placement");
  }
  get optionTooltipPlacement() {
    return this.getAttribute("option-tooltip-placement");
  }
  set optionTooltipFollowCursor(t) {
    t ? this.setAttribute("option-tooltip-follow-cursor", "true") : this.removeAttribute("option-tooltip-follow-cursor");
  }
  get optionTooltipFollowCursor() {
    return this.getAttribute("option-tooltip-follow-cursor") === "true";
  }
  set actionsPosition(t) {
    t ? this.setAttribute("actions-position", t) : this.removeAttribute("actions-position");
  }
  get actionsPosition() {
    return this.getAttribute("actions-position");
  }
  set actionsAlign(t) {
    t ? this.setAttribute("actions-align", t) : this.removeAttribute("actions-align");
  }
  get actionsAlign() {
    return this.getAttribute("actions-align");
  }
  set badgeTooltipPlacement(t) {
    t ? this.setAttribute("badge-tooltip-placement", t) : this.removeAttribute("badge-tooltip-placement");
  }
  get badgeTooltipPlacement() {
    return this.getAttribute("badge-tooltip-placement");
  }
  set getBadgeTooltipCallback(t) {
    this._getBadgeTooltipCallback = t, this.updatePicker({ getBadgeTooltipCallback: t });
  }
  get getBadgeTooltipCallback() {
    return this._getBadgeTooltipCallback;
  }
  set getRemoveButtonTooltipCallback(t) {
    this._getRemoveButtonTooltipCallback = t, this.updatePicker({ getRemoveButtonTooltipCallback: t });
  }
  get getRemoveButtonTooltipCallback() {
    return this._getRemoveButtonTooltipCallback;
  }
  set removeButtonTooltipText(t) {
    t ? this.setAttribute("remove-button-tooltip-text", t) : this.removeAttribute("remove-button-tooltip-text");
  }
  get removeButtonTooltipText() {
    return this.getAttribute("remove-button-tooltip-text");
  }
  set getCounterCallback(t) {
    this._getCounterCallback = t, this.updatePicker({ getCounterCallback: t });
  }
  get getCounterCallback() {
    return this._getCounterCallback;
  }
  // Event callbacks
  get beforeSearchCallback() {
    return this._beforeSearchCallback;
  }
  set beforeSearchCallback(t) {
    this._beforeSearchCallback = t, this.updatePicker({ beforeSearchCallback: t });
  }
  get beforeSelectCallback() {
    return this._beforeSelectCallback;
  }
  set beforeSelectCallback(t) {
    this._beforeSelectCallback = t, this.updatePicker({ beforeSelectCallback: t });
  }
  get beforeDeselectCallback() {
    return this._beforeDeselectCallback;
  }
  set beforeDeselectCallback(t) {
    this._beforeDeselectCallback = t, this.updatePicker({ beforeDeselectCallback: t });
  }
  get searchCallback() {
    return this._searchCallback;
  }
  set searchCallback(t) {
    this._searchCallback = t, this.updatePicker({ searchCallback: t });
  }
  get addNewCallback() {
    return this._addNewCallback;
  }
  set addNewCallback(t) {
    this._addNewCallback = t, this.updatePicker({ addNewCallback: t });
  }
  get onSelect() {
    return this._onSelect;
  }
  set onSelect(t) {
    this._onSelect = t;
  }
  get onDeselect() {
    return this._onDeselect;
  }
  set onDeselect(t) {
    this._onDeselect = t;
  }
  get onChange() {
    return this._onChange;
  }
  set onChange(t) {
    this._onChange = t;
  }
  // Action buttons
  get actionButtons() {
    return this._actionButtons;
  }
  set actionButtons(t) {
    this._actionButtons = t, this.updatePicker({ actionButtons: t });
  }
  // New public properties
  get selectedValue() {
    var t;
    return ((t = this.picker) == null ? void 0 : t.selectedValue) ?? null;
  }
  get selectedItem() {
    var t;
    return ((t = this.picker) == null ? void 0 : t.selectedItem) ?? null;
  }
  // ========================================================================
  // PUBLIC API - METHODS
  // ========================================================================
  getSelected() {
    return this.picker ? this.picker.getSelected() : [];
  }
  setSelected(t) {
    this.picker && this.picker.setSelected(t);
  }
  getValue() {
    return this.picker ? this.picker.getValue() : null;
  }
  destroy() {
    this.picker && this.picker.destroy();
  }
}
// Opt into the form-associated custom element lifecycle. This is what
// makes `form.reset()`, `form.elements`, and (in the future) constraint
// validation actually do something. Without this flag the element is
// invisible to the form lifecycle even when it has a `name`.
d(Me, "formAssociated", !0);
typeof window < "u" && typeof customElements < "u" && (customElements.get("web-multiselect") || customElements.define("web-multiselect", Me));
typeof window < "u" && (window.components = window.components || {}, window.components["web-multiselect"] = {
  version: () => "1.12.0-rc05",
  config: {
    name: "@keenmate/web-multiselect",
    version: "1.12.0-rc05",
    author: "Keenmate",
    license: "MIT",
    repository: "git+https://github.com/keenmate/web-multiselect.git",
    homepage: "https://web-multiselect.keenmate.dev"
  },
  logging: {
    enableLogging: bs,
    disableLogging: gs,
    setLogLevel: fs,
    setCategoryLevel: vs,
    getCategories: () => [...us]
  },
  register: () => {
    typeof customElements < "u" && !customElements.get("web-multiselect") && customElements.define("web-multiselect", Me);
  },
  getInstances: () => ct()
});
export {
  us as LOGGING_CATEGORIES,
  Me as MultiSelectElement,
  xs as WebMultiSelect,
  x as dataLogger,
  gs as disableLogging,
  bs as enableLogging,
  oe as initLogger,
  S as interactionLogger,
  vs as setCategoryLevel,
  fs as setLogLevel,
  P as uiLogger
};
