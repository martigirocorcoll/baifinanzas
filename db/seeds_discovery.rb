# Seeds for Articles and AppNews
# Run with: rails runner db/seeds_discovery.rb

puts "Seeding articles..."

articles_data = [
  {
    slug: 'fondos-indexados',
    title: 'Que es un fondo indexado?',
    excerpt: 'Los fondos indexados son una de las formas mas sencillas y eficientes de invertir a largo plazo.',
    category: 'inversion',
    read_time: 6,
    author: 'BaiFinanzas',
    published_at: 2.days.ago,
    body: <<~HTML
      <h5>Que es un fondo indexado?</h5>
      <p>Un fondo indexado es un tipo de fondo de inversion que replica un indice bursatil, como el S&P 500 o el MSCI World. En lugar de que un gestor elija acciones individualmente, el fondo simplemente compra todas las empresas que componen el indice.</p>

      <h5>Por que son tan populares?</h5>
      <p>Los fondos indexados se han convertido en la opcion preferida de muchos inversores por varias razones:</p>
      <ul>
        <li><strong>Comisiones bajas:</strong> Entre el 0.1% y el 0.3% anual, frente al 1-2% de los fondos tradicionales.</li>
        <li><strong>Diversificacion automatica:</strong> Con un solo fondo puedes invertir en cientos o miles de empresas.</li>
        <li><strong>Rentabilidad historica:</strong> A largo plazo, la mayoria de gestores profesionales no consiguen batir al indice.</li>
        <li><strong>Simplicidad:</strong> No necesitas elegir acciones individuales ni estar pendiente del mercado.</li>
      </ul>

      <h5>Como empezar?</h5>
      <p>Para invertir en fondos indexados necesitas:</p>
      <ol>
        <li>Abrir una cuenta en un broker o plataforma de inversion.</li>
        <li>Elegir un fondo que replique un indice global (como el MSCI World) o uno americano (como el S&P 500).</li>
        <li>Configurar una aportacion mensual automatica.</li>
        <li>Olvidarte y dejar que el interes compuesto trabaje por ti.</li>
      </ol>

      <h5>Cuanto puedo ganar?</h5>
      <p>Historicamente, el S&P 500 ha dado una rentabilidad media del 10% anual. Sin embargo, hay anos de subidas del 20-30% y anos de caidas del 10-20%. La clave es mantener la inversion a largo plazo (minimo 5-10 anos).</p>

      <div class="app-disclaimer mt-3">
        <small><i class="bi bi-info-circle me-1"></i> Rentabilidades pasadas no garantizan resultados futuros. Invertir conlleva riesgo de perdida.</small>
      </div>
    HTML
  },
  {
    slug: 'interes-compuesto',
    title: 'El poder del interes compuesto',
    excerpt: 'Descubre como el interes compuesto puede multiplicar tus ahorros con el tiempo.',
    category: 'inversion',
    read_time: 5,
    author: 'BaiFinanzas',
    published_at: 5.days.ago,
    body: <<~HTML
      <h5>Que es el interes compuesto?</h5>
      <p>El interes compuesto es el interes que se calcula sobre el capital inicial y sobre los intereses acumulados de periodos anteriores. En otras palabras: <strong>ganas intereses sobre tus intereses</strong>.</p>

      <h5>Un ejemplo practico</h5>
      <p>Imagina que inviertes 200 euros al mes con una rentabilidad del 8% anual:</p>
      <ul>
        <li><strong>En 10 anos:</strong> habras aportado 24.000 euros y tendras unos 36.600 euros.</li>
        <li><strong>En 20 anos:</strong> habras aportado 48.000 euros y tendras unos 117.800 euros.</li>
        <li><strong>En 30 anos:</strong> habras aportado 72.000 euros y tendras unos 298.000 euros.</li>
      </ul>
      <p>Fijate que en los ultimos 10 anos es donde se genera la mayor parte de las ganancias. Eso es el efecto del interes compuesto.</p>

      <h5>La regla del 72</h5>
      <p>Hay un truco sencillo para saber cuanto tarda en duplicarse tu dinero: divide 72 entre la rentabilidad anual.</p>
      <ul>
        <li>Al 4%: tu dinero se duplica en 18 anos.</li>
        <li>Al 8%: tu dinero se duplica en 9 anos.</li>
        <li>Al 12%: tu dinero se duplica en 6 anos.</li>
      </ul>

      <h5>El factor mas importante: el tiempo</h5>
      <p>Cuanto antes empieces a invertir, mas tiempo tiene el interes compuesto para trabajar. Empezar 10 anos antes puede suponer el doble de capital final, incluso aportando la misma cantidad mensual.</p>

      <div class="app-disclaimer mt-3">
        <small><i class="bi bi-calculator me-1"></i> Usa nuestra calculadora de interes compuesto para ver cuanto podrias acumular.</small>
      </div>
    HTML
  },
  {
    slug: 'fondo-emergencia',
    title: 'Como crear tu fondo de emergencia',
    excerpt: 'Todo plan financiero empieza por tener un colchon de seguridad. Te explicamos como crearlo.',
    category: 'ahorro',
    read_time: 4,
    author: 'BaiFinanzas',
    published_at: 1.week.ago,
    body: <<~HTML
      <h5>Que es un fondo de emergencia?</h5>
      <p>Un fondo de emergencia es un colchon de dinero guardado para cubrir gastos imprevistos: una averia del coche, una reparacion en casa, un periodo sin trabajo, o cualquier gasto inesperado.</p>

      <h5>Cuanto necesitas?</h5>
      <p>La recomendacion general es tener entre <strong>3 y 6 meses de gastos</strong> guardados. Si tus gastos mensuales son de 1.500 euros, necesitarias entre 4.500 y 9.000 euros.</p>
      <p>Factores que pueden hacer que necesites mas:</p>
      <ul>
        <li>Si eres autonomo o freelance (ingresos irregulares).</li>
        <li>Si tienes hijos o personas a tu cargo.</li>
        <li>Si tu sector laboral tiene alta rotacion.</li>
      </ul>

      <h5>Donde guardarlo?</h5>
      <p>El fondo de emergencia debe estar en un sitio <strong>seguro y accesible</strong>:</p>
      <ul>
        <li><strong>Cuenta de ahorro remunerada:</strong> Acceso inmediato, algo de rentabilidad.</li>
        <li><strong>Deposito a corto plazo:</strong> Mejor rentabilidad, acceso en dias.</li>
      </ul>
      <p>No lo inviertas en acciones, fondos o criptomonedas. El fondo de emergencia no es para ganar dinero, es para tener tranquilidad.</p>

      <h5>Como crearlo paso a paso</h5>
      <ol>
        <li>Calcula tus gastos mensuales fijos.</li>
        <li>Multiplica por 4 (minimo recomendado).</li>
        <li>Resta lo que ya tienes ahorrado.</li>
        <li>Divide la diferencia entre los meses en que quieres conseguirlo.</li>
        <li>Configura una transferencia automatica mensual a tu cuenta de ahorro.</li>
      </ol>

      <div class="app-disclaimer mt-3">
        <small><i class="bi bi-calculator me-1"></i> Usa nuestra calculadora de fondo de emergencia para calcular exactamente cuanto necesitas.</small>
      </div>
    HTML
  },
  {
    slug: 'regla-50-30-20',
    title: 'La regla 50/30/20 para tu presupuesto',
    excerpt: 'Un metodo sencillo para organizar tus ingresos y empezar a ahorrar desde hoy.',
    category: 'presupuesto',
    read_time: 4,
    author: 'BaiFinanzas',
    published_at: 10.days.ago,
    body: <<~HTML
      <h5>Que es la regla 50/30/20?</h5>
      <p>Es un metodo sencillo para organizar tus ingresos en tres categorias:</p>
      <ul>
        <li><strong>50% Necesidades:</strong> Vivienda, alimentacion, transporte, seguros, servicios basicos.</li>
        <li><strong>30% Deseos:</strong> Ocio, restaurantes, viajes, compras no esenciales, suscripciones.</li>
        <li><strong>20% Ahorro e inversion:</strong> Fondo de emergencia, inversiones, pago extra de deudas.</li>
      </ul>

      <h5>Un ejemplo con 2.000 euros netos</h5>
      <ul>
        <li><strong>1.000 euros</strong> para necesidades (alquiler, comida, facturas).</li>
        <li><strong>600 euros</strong> para deseos (ocio, restaurantes, compras).</li>
        <li><strong>400 euros</strong> para ahorro e inversion.</li>
      </ul>

      <h5>Y si no llego al 20%?</h5>
      <p>No pasa nada. Lo importante es empezar. Si ahora solo puedes ahorrar un 5%, empieza por ahi. El habito es mas importante que el porcentaje.</p>
      <p>Revisa tus gastos para ver donde puedes ajustar. Los "gastos hormiga" (cafes diarios, suscripciones que no usas) suman mas de lo que parece.</p>

      <h5>Adapta la regla a tu situacion</h5>
      <p>Si vives en una ciudad cara donde el alquiler absorbe mas del 50%, ajusta los porcentajes. Lo importante es que siempre destines algo al ahorro, aunque sea un 10%.</p>

      <div class="app-disclaimer mt-3">
        <small><i class="bi bi-lightbulb me-1"></i> Revisa tus gastos del ultimo mes y clasifikalos en estas tres categorias. Te sorprendera donde va tu dinero.</small>
      </div>
    HTML
  },
  {
    slug: 'gestionar-deudas',
    title: 'Como gestionar tus deudas de forma inteligente',
    excerpt: 'No todas las deudas son iguales. Aprende a priorizar y eliminar las que te cuestan dinero.',
    category: 'deudas',
    read_time: 5,
    author: 'BaiFinanzas',
    published_at: 2.weeks.ago,
    body: <<~HTML
      <h5>No todas las deudas son iguales</h5>
      <p>Hay deudas "buenas" y deudas "malas":</p>
      <ul>
        <li><strong>Deuda buena:</strong> Hipoteca a tipo bajo, prestamo para formacion que mejora tu salario.</li>
        <li><strong>Deuda mala:</strong> Tarjetas de credito a intereses altos, prestamos personales para consumo, financiaciones "a plazos" con intereses ocultos.</li>
      </ul>

      <h5>Prioriza las deudas caras</h5>
      <p>Si tienes varias deudas, hay dos estrategias populares:</p>
      <ul>
        <li><strong>Metodo avalancha:</strong> Paga primero la deuda con mayor tipo de interes. Es la opcion mas eficiente matematicamente.</li>
        <li><strong>Metodo bola de nieve:</strong> Paga primero la deuda mas pequena. La satisfaccion de eliminar deudas te motiva a seguir.</li>
      </ul>

      <h5>Cuanto te cuesta realmente la deuda?</h5>
      <p>Una tarjeta de credito al 20% TAE convierte una compra de 1.000 euros en 1.200 euros si tardas un ano en pagarla. Si tardas 2 anos, puede llegar a 1.440 euros. Los intereses se acumulan rapidamente.</p>

      <h5>Plan de accion</h5>
      <ol>
        <li>Lista todas tus deudas: importe, tipo de interes, cuota mensual.</li>
        <li>Ordenalas de mayor a menor interes.</li>
        <li>Paga el minimo en todas excepto en la primera.</li>
        <li>Destina todo el dinero extra a la deuda con mayor interes.</li>
        <li>Cuando la elimines, pasa al siguiente.</li>
      </ol>

      <div class="app-disclaimer mt-3">
        <small><i class="bi bi-info-circle me-1"></i> Si tienes hipoteca y dinero extra, usa nuestra calculadora de amortizacion anticipada para ver si te conviene mas amortizar o invertir.</small>
      </div>
    HTML
  },
  {
    slug: 'empezar-invertir',
    title: 'Primeros pasos para invertir',
    excerpt: 'Invertir no es solo para expertos. Con estos pasos basicos puedes empezar hoy.',
    category: 'inversion',
    read_time: 6,
    author: 'BaiFinanzas',
    published_at: 3.weeks.ago,
    body: <<~HTML
      <h5>Invertir no es especular</h5>
      <p>Invertir significa poner tu dinero a trabajar para generar rentabilidad a largo plazo. No es comprar y vender acciones cada dia, ni apostar en criptomonedas. Es un proceso lento, aburrido y muy efectivo.</p>

      <h5>Requisitos antes de invertir</h5>
      <p>Antes de empezar a invertir, asegurate de tener:</p>
      <ol>
        <li><strong>Un fondo de emergencia completo</strong> (3-6 meses de gastos).</li>
        <li><strong>Sin deudas caras</strong> (tarjetas de credito, prestamos al consumo).</li>
        <li><strong>Un presupuesto controlado</strong> (sabes cuanto ganas, gastas y ahorras).</li>
        <li><strong>Dinero que no vas a necesitar</strong> en al menos 5 anos.</li>
      </ol>

      <h5>Opciones para empezar</h5>
      <p>De menor a mayor riesgo y rentabilidad esperada:</p>
      <ul>
        <li><strong>Depositos:</strong> Seguro, rentabilidad baja (1-3%). Ideal para dinero que necesitaras en 1-2 anos.</li>
        <li><strong>Fondos indexados:</strong> Diversificado, rentabilidad historica del 7-10%. Para plazos de 5+ anos.</li>
        <li><strong>Acciones individuales:</strong> Mayor riesgo, requiere conocimiento. Solo para dinero que te puedes permitir perder.</li>
      </ul>

      <h5>Cuanto invertir?</h5>
      <p>Puedes empezar con cantidades pequenas. Lo importante es la constancia. Invertir 100 euros al mes de forma automatica es mejor que esperar a tener "suficiente dinero".</p>

      <div class="app-disclaimer mt-3">
        <small><i class="bi bi-calculator me-1"></i> Usa nuestra calculadora de objetivo de inversion para saber cuanto necesitas invertir al mes para alcanzar tu meta.</small>
      </div>
    HTML
  },
  {
    slug: 'errores-ahorro',
    title: '5 errores que te impiden ahorrar',
    excerpt: 'Si te cuesta llegar a fin de mes, quiza estes cometiendo alguno de estos errores comunes.',
    category: 'ahorro',
    read_time: 4,
    author: 'BaiFinanzas',
    published_at: 1.month.ago,
    body: <<~HTML
      <h5>1. No tener un presupuesto</h5>
      <p>Si no sabes cuanto gastas, no puedes saber cuanto puedes ahorrar. Dedica 30 minutos a revisar tus gastos del ultimo mes. No necesitas una app compleja: una hoja de calculo o incluso papel y boli sirven.</p>

      <h5>2. Ahorrar lo que sobra (en vez de lo primero)</h5>
      <p>La mayoria de personas ahorra lo que sobra a final de mes. El problema: nunca sobra nada. Dale la vuelta: <strong>pagate a ti primero</strong>. Configura una transferencia automatica el dia que cobras.</p>

      <h5>3. No tener un objetivo claro</h5>
      <p>Ahorrar "por ahorrar" no funciona a largo plazo. Ponle nombre a tu ahorro: fondo de emergencia, vacaciones, entrada del piso. Tener un objetivo concreto te motiva a mantener el habito.</p>

      <h5>4. Gastar en cosas pequenas sin darte cuenta</h5>
      <p>Los gastos hormiga son traicioneros: un cafe de 2 euros al dia son 60 al mes. Una suscripcion de streaming que no ves son 15 al mes. Revisa tus recibos bancarios y cancela lo que no uses.</p>

      <h5>5. Esperar al momento perfecto</h5>
      <p>No existe el momento perfecto para empezar a ahorrar. Siempre habra un gasto inesperado, una compra necesaria o una excusa. El mejor momento para empezar fue ayer. El segundo mejor momento es hoy.</p>

      <div class="app-disclaimer mt-3">
        <small><i class="bi bi-lightbulb me-1"></i> Empieza hoy: configura una transferencia automatica mensual, aunque sea de 50 euros.</small>
      </div>
    HTML
  },
  {
    slug: 'como-funciona-hipoteca',
    title: 'Como funciona una hipoteca',
    excerpt: 'Fija, variable o mixta? Entiende los tipos de hipoteca antes de firmar nada.',
    category: 'conceptos',
    read_time: 7,
    author: 'BaiFinanzas',
    published_at: 5.weeks.ago,
    body: <<~HTML
      <h5>Que es una hipoteca?</h5>
      <p>Una hipoteca es un prestamo que te da un banco para comprar una vivienda. La vivienda queda como garantia: si no pagas, el banco puede quedarsela. Las hipotecas suelen ser de 15 a 30 anos.</p>

      <h5>Los tres tipos de hipoteca</h5>
      <ul>
        <li><strong>Tipo fijo:</strong> La cuota no cambia nunca. Sabes exactamente cuanto pagaras cada mes durante toda la vida del prestamo. Suele tener un interes algo mas alto que el variable al principio.</li>
        <li><strong>Tipo variable:</strong> La cuota se revisa cada 6 o 12 meses segun el Euribor. Si el Euribor sube, tu cuota sube. Si baja, tu cuota baja.</li>
        <li><strong>Tipo mixto:</strong> Los primeros anos (3-10) tienes un tipo fijo, y despues pasa a variable. Es un punto intermedio entre seguridad y posible ahorro.</li>
      </ul>

      <h5>Que es el Euribor?</h5>
      <p>El Euribor es el tipo de interes al que los bancos europeos se prestan dinero entre si. Es la referencia para las hipotecas variables en Europa. Si el Banco Central Europeo sube tipos, el Euribor sube, y tu cuota variable tambien.</p>

      <h5>Cuanto puedo pedir?</h5>
      <p>La regla general es que la cuota de la hipoteca no supere el <strong>30-35% de tus ingresos netos</strong>. Si ganas 2.000 euros netos, tu cuota no deberia pasar de 600-700 euros.</p>
      <p>Ademas, necesitaras aportar entre el 20-30% del precio de la vivienda como entrada (el banco suele financiar el 80%).</p>

      <h5>Gastos que debes tener en cuenta</h5>
      <ul>
        <li>Impuesto de Transmisiones Patrimoniales (vivienda usada) o IVA (nueva).</li>
        <li>Notaria, registro y gestoria.</li>
        <li>Tasacion del inmueble.</li>
        <li>Seguros (hogar, vida).</li>
      </ul>

      <div class="app-disclaimer mt-3">
        <small><i class="bi bi-calculator me-1"></i> Usa nuestra calculadora de hipotecas para simular tu cuota con los tres tipos: fijo, mixto y variable.</small>
      </div>
    HTML
  }
]

articles_data.each do |data|
  Article.find_or_create_by!(slug: data[:slug]) do |article|
    article.title = data[:title]
    article.excerpt = data[:excerpt]
    article.body = data[:body]
    article.category = data[:category]
    article.read_time = data[:read_time]
    article.author = data[:author]
    article.published_at = data[:published_at]
    article.active = true
  end
end

puts "  Created #{Article.count} articles"

puts "Seeding app news..."

news_data = [
  {
    title: 'Bienvenido a BaiFinanzas Beta!',
    content: 'Gracias por ser de los primeros en probar BaiFinanzas. Tu opinion nos ayuda a mejorar. Si encuentras algun error o tienes sugerencias, no dudes en contactarnos.',
    published_at: 1.day.ago
  },
  {
    title: '7 calculadoras financieras disponibles',
    content: 'Ya puedes usar nuestras 7 calculadoras: interes compuesto, hipoteca (fija, mixta y variable), fondo de emergencia, libertad financiera, objetivo de inversion, amortizacion anticipada y rentabilidad.',
    published_at: 3.days.ago
  },
  {
    title: 'Tu plan financiero personalizado',
    content: 'Con solo 4 datos calculamos tu nivel financiero y te damos un plan de accion con tareas concretas. Actualiza tus datos para ver como sube tu nivel.',
    published_at: 1.week.ago
  },
  {
    title: 'Proximamente: mas contenido',
    content: 'Estamos preparando mas articulos, videos y herramientas para ayudarte en tu camino financiero. Mantente atento a las novedades!',
    published_at: 2.weeks.ago
  }
]

news_data.each do |data|
  AppNews.find_or_create_by!(title: data[:title]) do |news|
    news.content = data[:content]
    news.published_at = data[:published_at]
    news.active = true
  end
end

puts "  Created #{AppNews.count} news items"
puts "Done!"
